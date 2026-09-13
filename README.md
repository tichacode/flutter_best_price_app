# best_price_app

Framework : Flutter\
A simple Flutter app that helps you find the cheapest option among similar products — by comparing **price per unit**

https://github.com/user-attachments/assets/c6e482b1-c5fc-4241-8747-bfb2d5dda0ca
 
## 📌 Description

- Organize comparisons into **notes** (e.g. "Grocery run", "Hardware store")
- Add each product's price, pack size, and quantity per unit
- The app calculates price-per-unit for every item and ranks the top 3 cheapest
- All data stays on your device — no account, no internet required
- Runs on **Android** and **Web**


## 🛠 How to Use
 
1. Tap **+ Add** to create a new note and give it a name.
2. Inside the note, tap **+ Add** to enter a product's **Price**, **Piece** (pack size), **Quantity per unit**, and an optional note.
3. Tap **Calculate!** to see every item ranked by price-per-unit, cheapest first — the top 3 get a crown 👑.
4. Edit or delete any item with the ✏️ / 🗑️ icons, and edit or delete the note name from its header.
5. Open the drawer (☰) to switch between notes.


## ⚙️ How It Works
 
- Built with **Flutter**, targeting Android and Web from one codebase
- Data is stored locally with **SQLite** (`sqflite` on Android, `sqflite_common_ffi_web` on Web)
- two data tables, `pack_price` (notes) and `product_price` (items), linked by `pack_id`
- Price-per-unit formula: `price ÷ (piece × quantity)`


## 🚀 Run It Locally
 
```bash
flutter pub get
flutter run
```

## 🚀 Require package
```bash
flutter pub add sqflite path
dart run sqflite_common_ffi_web:setup
flutter pub add path_provider
```

## 📁 Project Structure
 
| File | Purpose |
|---|---|
| `main.dart` | App entry point |
| `screen_main_drawer.dart` | Drawer navigation + main list screen |
| `screen_input.dart` | Add/edit forms for notes and items |
| `screen_result.dart` | Calculated results & ranking screen |
| `database_helper.dart` | SQLite schema & queries |
| `items_format.dart` | Shared header widgets |
| `extention.dart` | Dashed divider widget |
 
