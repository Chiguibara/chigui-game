#!/usr/bin/env python3
"""Creates or updates the real-money packs as Google Play one-time products
and activates them (Google Play Developer API, monetization.onetimeproducts).

Run by hand from GitHub Actions (.github/workflows/play-products.yml), which
passes the Play service account key in PLAY_SERVICE_ACCOUNT_JSON. Running it
again only updates the products. Pass --dry-run to print the prices without
changing anything.

The pack ids must match `packs` in lib/game/catalog.dart. Prices are what a
player in the eurozone pays, tax included; Play converts them for the other
countries.
"""

import argparse
import json
import os
import sys
from decimal import ROUND_HALF_UP, Decimal

import requests
from google.auth.transport.requests import AuthorizedSession
from google.oauth2 import service_account

PACKAGE = "es.chiguibara.chigui_game"
API = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications"
PURCHASE_OPTION = "buy"

PACKS = [
    {
        "id": "pack_geek",
        "eur": "1.99",
        "listings": {
            "es-ES": (
                "Pack friki",
                "Gafas pixeladas, sombrero de mago y portátil con pegatinas "
                "para Chigüi. Solo para vestirle: no cambia el juego.",
            ),
            "en-US": (
                "Geek pack",
                "Pixel glasses, a wizard hat, and a laptop with stickers for "
                "Chigüi. Just for dressing up: it does not change the game.",
            ),
        },
    },
    {
        "id": "pack_sweet",
        "eur": "0.99",
        "listings": {
            "es-ES": (
                "Pack dulce",
                "Orejas de conejo, gafas de corazón y una magdalena para "
                "Chigüi. Solo para vestirle: no cambia el juego.",
            ),
            "en-US": (
                "Sweet pack",
                "Bunny ears, heart glasses, and a cupcake for Chigüi. Just "
                "for dressing up: it does not change the game.",
            ),
        },
    },
]

# Spain's VAT, to turn the eurozone price (tax included) into the tax-free
# price Play converts from.
SPAIN_VAT = Decimal("1.21")


def money(currency: str, amount: Decimal) -> dict:
    units = int(amount)
    nanos = int(((amount - units) * 1_000_000_000).to_integral_value())
    return {"currencyCode": currency, "units": str(units), "nanos": nanos}


def amount(m: dict) -> Decimal:
    return Decimal(m.get("units", "0")) + Decimal(m.get("nanos", 0)) / 1_000_000_000


def check(response: requests.Response) -> dict:
    if not response.ok:
        sys.exit(f"{response.request.method} {response.url}\n{response.text}")
    return response.json()


def regional_prices(session, eur: Decimal):
    """Play's price for every region, from the eurozone price: eurozone
    regions get exactly that price, the rest Play's conversion."""
    tax_free = (eur / SPAIN_VAT).quantize(Decimal("0.01"), ROUND_HALF_UP)
    converted = check(
        session.post(
            f"{API}/{PACKAGE}/pricing:convertRegionPrices",
            json={"price": money("EUR", tax_free)},
        )
    )
    regions = []
    for code, region in sorted(converted["convertedRegionPrices"].items()):
        price = region["price"]
        if price["currencyCode"] == "EUR":
            price = money("EUR", eur)
        regions.append(
            {"regionCode": code, "price": price, "availability": "AVAILABLE"}
        )
    other = converted["convertedOtherRegionsPrice"]
    return regions, other, converted["regionVersion"]["version"]


def product(pack: dict, regions: list, other: dict) -> dict:
    return {
        "packageName": PACKAGE,
        "productId": pack["id"],
        "listings": [
            {"languageCode": lang, "title": title, "description": description}
            for lang, (title, description) in pack["listings"].items()
        ],
        "purchaseOptions": [
            {
                "purchaseOptionId": PURCHASE_OPTION,
                # Readable by the Billing Library's one-time purchase details.
                "buyOption": {"legacyCompatible": True},
                "regionalPricingAndAvailabilityConfigs": regions,
                "newRegionsConfig": {
                    "eurPrice": other["eurPrice"],
                    "usdPrice": other["usdPrice"],
                    "availability": "AVAILABLE",
                },
            }
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    credentials = service_account.Credentials.from_service_account_info(
        json.loads(os.environ["PLAY_SERVICE_ACCOUNT_JSON"]),
        scopes=["https://www.googleapis.com/auth/androidpublisher"],
    )
    session = AuthorizedSession(credentials)

    for pack in PACKS:
        regions, other, version = regional_prices(session, Decimal(pack["eur"]))
        spain = next(r["price"] for r in regions if r["regionCode"] == "ES")
        us = next((r["price"] for r in regions if r["regionCode"] == "US"), None)
        print(
            f"{pack['id']}: {len(regions)} regions, Spain {amount(spain)} EUR"
            + (f", United States {amount(us)} USD" if us else "")
        )
        if args.dry_run:
            continue

        saved = check(
            session.patch(
                f"{API}/{PACKAGE}/onetimeproducts/{pack['id']}",
                params={
                    "allowMissing": "true",
                    "regionsVersion.version": version,
                    "updateMask": "listings,purchaseOptions",
                },
                json=product(pack, regions, other),
            )
        )
        state = saved["purchaseOptions"][0].get("state")
        if state != "ACTIVE":
            check(
                session.post(
                    f"{API}/{PACKAGE}/oneTimeProducts/{pack['id']}"
                    "/purchaseOptions:batchUpdateStates",
                    json={
                        "requests": [
                            {
                                "activatePurchaseOptionRequest": {
                                    "packageName": PACKAGE,
                                    "productId": pack["id"],
                                    "purchaseOptionId": PURCHASE_OPTION,
                                }
                            }
                        ]
                    },
                )
            )
            state = "ACTIVE (activated now)"
        print(f"  saved; purchase option {state}")


if __name__ == "__main__":
    main()
