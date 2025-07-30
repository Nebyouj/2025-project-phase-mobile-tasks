🛍️ Shoe Store - Ecommerce Flutter App
This is a simple ecommerce mobile application built using Flutter. The app allows users to create, view, update, and delete products. The focus of this project is on implementing navigation and routing features to ensure a seamless user experience.

✨ Features
📦 View a list of products on the Home screen

➕ Add a new product or ✏️ edit existing ones

🔍 Search through products using the Search page

🔁 Smooth transitions and animated navigation

📱 Back button functionality handled appropriately

🧭 Navigation Implementation
✅ Named Routes used for all screen transitions

✅ Data passed between screens for product operations

✅ Back button navigation handled manually

✅ Custom animated transitions for enhanced UX

📱 Screens
HomePage — Displays a list of all products

AddUpdatePage — Used to add or update products

SearchPage — Allows searching through products

ProductDetailsPage — Displays detailed view of a selected product

🗂️ Project Structure
bash
Copy
Edit
lib/
├── main.dart                # App entry point with routes
├── models/
│   └── product.dart         # Product model class
├── screens/
│   ├── home_page.dart       # Home screen UI
│   ├── add_update_page.dart# Add/edit product screen
│   ├── search_page.dart     # Product search screen
│   └── product_details.dart # Single product view screen
└── widgets/
    └── product_tile.dart    # UI widget for product listing
🚀 How to Run
Make sure you have Flutter installed.

Clone the repository:

bash
Copy
Edit
git clone https://github.com/your-username/shoe-store-flutter.git
cd shoe-store-flutter
Run the app:

bash
Copy
Edit
flutter pub get
flutter run