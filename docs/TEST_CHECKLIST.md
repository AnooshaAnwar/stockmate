# StockMate Test Checklist

Tested on: <Chrome (Flutter web)>
Flutter version: <run `flutter --version`>
Date: <30 Oct 2026>
Tester: <Anoosha Anwar>

## 1. Product list

| # | Test | Expected result | Result |
|---|------|-----------------|--------|
| 1.1 | Open the app for the first time | 3 sample products appear | |
| 1.2 | Look at each product row | Name, price, quantity and stock badge are visible | |
| 1.3 | Product with quantity 0 | Red "Out of Stock" badge | |
| 1.4 | Product with quantity 1 to 5 | Orange "Low Stock" badge | |
| 1.5 | Product with quantity above 5 | Green "In Stock" badge | |
| 1.6 | Delete every product | "No products yet" empty screen appears | |

## 2. Add product

| # | Test | Expected result | Result |
|---|------|-----------------|--------|
| 2.1 | Tap Add Product, fill all fields, tap Add Product | Product appears in the list immediately | |
| 2.2 | Add a product with the category left empty | Saved with no category line shown | |
| 2.3 | Leave name empty and save | "Product name is required" error, nothing saved | |
| 2.4 | Enter 51 or more characters in name | Name length error | |
| 2.5 | Enter `abc` as price | "Enter a valid number" error | |
| 2.6 | Enter `0` or `-5` as price | "Price must be greater than 0" error | |
| 2.7 | Enter `2.5` as quantity | "Enter a whole number" error | |
| 2.8 | Enter `-1` as quantity | "Quantity cannot be negative" error | |
| 2.9 | Leave price and quantity empty | "required" errors on both fields | |
| 2.10 | Press back without saving | Returns to list, no product added | |

## 3. Edit product

| # | Test | Expected result | Result |
|---|------|-----------------|--------|
| 3.1 | Tap a product row | Edit screen opens with fields pre-filled |pass |
| 3.2 | Change the name and save | List shows the new name |pass |
| 3.3 | Change price and quantity and save | Both update, badge updates to match |pass |
| 3.4 | Enter invalid values while editing | Same validation errors as the add form |pass |
| 3.5 | Press back without saving | Product is unchanged | |

## 4. Quantity controls

| # | Test | Expected result | Result |
|---|------|-----------------|--------|
| 4.1 | Tap + | Quantity goes up by 1 |pass |
| 4.2 | Tap - | Quantity goes down by 1 |pass |
| 4.3 | Reduce quantity to 0 | Badge becomes "Out of Stock" |pass |
| 4.4 | Look at the - button at quantity 0 | Button is disabled, quantity cannot go negative | pass|
| 4.5 | Raise quantity from 0 to 1 | Badge changes from Out of Stock to Low Stock |pass |
| 4.6 | Raise quantity from 5 to 6 | Badge changes from Low Stock to In Stock |pass |

## 5. Delete product

| # | Test | Expected result | Result |
|---|------|-----------------|--------|
| 5.1 | Tap the trash icon | Confirmation dialog appears |pass |
| 5.2 | Tap Cancel | Product stays in the list |pass |
| 5.3 | Tap Delete | Product is removed and a snackbar appears | pass|

## 6. Persistence

| # | Test | Expected result | Result |
|---|------|-----------------|--------|
| 6.1 | Add a product, fully close the app, reopen | Product is still there |pass |
| 6.2 | Edit a product, close and reopen | Edit is kept |pass |
| 6.3 | Change a quantity, close and reopen | New quantity is kept | |
| 6.4 | Delete a product, close and reopen | Product stays deleted | |
| 6.5 | Delete everything, close and reopen | Empty screen shows, sample products do not return | |

## 7. Usability and small screens

| # | Test | Expected result | Result |
|---|------|-----------------|--------|
| 7.1 | Run on a small phone or small emulator | No overflow errors on list or form | |
| 7.2 | Add a product with a very long name | Name is cut off with "..." and layout holds |pass |
| 7.3 | Open the form with the keyboard showing | Form scrolls and fields are reachable | pass|
| 7.4 | Add 15 or more products | List scrolls and the last item is not hidden by the button |pass |
| 7.5 | Rotate the device | No crash, layout still usable | |

## 8. Automated tests

| # | Test | Expected result | Result |
|---|------|-----------------|--------|
| 8.1 | Run `flutter test` | "All tests passed!" | pass|
