# Product CRUD App

A full-stack product management app using:
- **Flutter** (with Provider) for frontend
- **Node.js + Express** for backend API
- **SQL Server** for the database

---

## 📁 Folder Structure

```
product_crud_app/
├── backend/              # Node.js + Express API
│   ├── db/
│   ├── routes/
│   ├── controllers/
│   ├── sql/products_table.sql  ← Database creation script
├── frontend/
│   └── product_app/      # Flutter frontend app
```

---

## 🌐 API Base URL

```
http://localhost:3030
```

> ⚠️ Replace with your actual IP address if testing on a different network.

---

## 🗃️ Database Setup (SQL Server)

### 1. Create Database

In SQL Server Management Studio (SSMS):

```sql
CREATE DATABASE ProductDB;
```

Then select the new database:

```sql
USE ProductDB;
```

### 2. Create `PRODUCTS` Table & Sample Data

Run this script in SSMS or your preferred SQL editor:

```sql
-- Create the PRODUCTS table
CREATE TABLE PRODUCTS (
    PRODUCTID INT PRIMARY KEY IDENTITY(1,1),
    PRODUCTNAME NVARCHAR(100) NOT NULL,
    PRICE DECIMAL(10,2) NOT NULL,
    STOCK INT NOT NULL
);

-- Insert sample products
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('USB Flash Drive', 9.99, 8);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Vanilla Almond Granola', 4.29, 13);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Cereal Dispenser with Portion Control', 24.99, 35);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Car Seat Organizer', 14.99, 23);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Italian Sausage and Peppers', 8.99, 31);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Tennis Racket', 89.99, 31);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Kid''s Fruit Snacks', 2.49, 18);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Chocolate Protein Powder', 24.99, 47);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Cinnamon Sugar Donuts', 4.99, 48);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Whisk Set', 12.99, 44);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Overnight Duffle Bag', 34.99, 32);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Herbal Tea Infuser', 9.99, 39);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Adjustable Garden Rake', 22.99, 13);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Portable Solar Charger', 29.99, 5);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Banana Nut Muffins', 4.49, 5);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Portable Air Conditioner', 299.99, 32);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Hummus Variety Pack', 5.99, 37);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Portable Bluetooth Headphones', 79.99, 30);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Bluetooth Sleep Headphones', 29.99, 16);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Fitness Resistance Bands Set', 34.99, 16);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Savory Quinoa Pudding', 2.99, 38);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Vegetarian Stir Fry Sauce', 2.49, 10);
insert into PRODUCTS (PRODUCTNAME, PRICE, STOCK) values ('Bamboo Toothbrush Holder', 14.99, 17);
```

Alternatively, run the included file:
```
/backend/sql/products_table.sql
```

---

## 🚀 Backend Setup (`/backend`)

### Prerequisites:
- Node.js installed
- SQL Server running
- Database created and populated

### 1. Install dependencies

```bash
cd backend
npm install
```

### 2. Configure `.env`

Create a `.env` file with your SQL credentials:

```env
DB_USER=your_sql_user
DB_PASSWORD=your_password
DB_SERVER=localhost
DB_PORT=1433
DB_DATABASE=ProductDB
```

### 3. Run the API server

```bash
node server.js
```

API will run on: [http://localhost:3030/products](http://localhost:3030/products)

---
## 🔌 API Endpoints

All endpoints are prefixed with:

```
http://<your-server-ip>:3030/products
```

Replace `<your-server-ip>` with your actual IP or `localhost` for local development.

---

### 📄 GET /products

Get a paginated list of products.

**Query Parameters:**
- `page` (required): Page number (e.g. `1`)
- `pageSize` (optional): Number of items per page (default: 10)
- `search` (optional): Filter products by name (e.g. `mouse`)
- `sort` (optional): Sort by `price` or `stock`

**Example:**
```
GET /products?page=1&pageSize=10&search=mouse&sort=price
```

**Response:**
```json
{
  "products": [ ... ],
  "pagination": {
    "totalItems": 50,
    "currentPage": 1,
    "totalPages": 5
  }
}
```

---

### 📄 GET /products/:id

Get a single product by ID.

**Example:**
```
GET /products/5
```

---

### ➕ POST /products

Create a new product.

**Body (JSON):**
```json
{
  "PRODUCTNAME": "New Item",
  "PRICE": 19.99,
  "STOCK": 100
}
```

---

### 📝 PUT /products/:id

Update an existing product.

**Example:**
```
PUT /products/5
```

**Body (JSON):**
```json
{
  "PRODUCTNAME": "Updated Item",
  "PRICE": 29.99,
  "STOCK": 75
}
```

---

### ❌ DELETE /products/:id

Delete a product by ID.

**Example:**
```
DELETE /products/5
```


## 💻 Frontend Setup (`/frontend/product_app`)

### Prerequisites:
- Flutter SDK installed
- Emulator or device ready
- API reachable via device IP

### 1. Open the Flutter app folder

```bash
cd frontend/product_app
```

### 2. Install dependencies

```bash
flutter pub get
```
### 3. Change Base Url for the app commmunication 


```
product_crud_app/
├── backend/              # Node.js + Express API
├── frontend/
│   └── product_app/      # Flutter frontend app
|       └──lib/
|          └──Services/
|             └──product_service.dart     #change baseUrl in this file with your IPV4 Address Ex:192.168.1.198
```


### 4. Run the app

```bash
flutter run
```

> ⚠️ Make sure the `baseUrl` in your `ProductService` matches your backend IP and port.

---

## ✅ Features

- List products with lazy loading
- Pull-to-refresh
- Add, edit, and delete products
- Field validation
- Confirmation dialog before delete
- Clean state management with Provider

---

## 📄 License

This project is for educational/demo purposes. Use and modify freely.
