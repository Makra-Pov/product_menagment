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
http://192.168.1.198:3030
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
INSERT INTO PRODUCTS (PRODUCTNAME, PRICE, STOCK) VALUES
('Keyboard', 25.99, 50),
('Mouse', 15.49, 75),
('Monitor', 150.00, 20),
('Laptop Stand', 30.00, 15),
('USB-C Cable', 9.99, 100);
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

### 3. Run the app

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
