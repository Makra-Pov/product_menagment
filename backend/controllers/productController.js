const sql = require("mssql");
const config = require("../db/config");

exports.getAllProducts = async (req, res) => {
  try {
    await sql.connect(config);
    const result = await sql.query`SELECT * FROM PRODUCTS`;
    res.json(result.recordset);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getProductById = async (req, res) => {
  const id = req.params.id;
  try {
    await sql.connect(config);
    const result = await sql.query`SELECT * FROM PRODUCTS WHERE PRODUCTID = ${id}`;
    if (result.recordset.length > 0) res.json(result.recordset[0]);
    else res.status(404).json({ message: "Product not found" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createProduct = async (req, res) => {
  const { PRODUCTNAME, PRICE, STOCK } = req.body;
  if (!PRODUCTNAME || PRICE <= 0 || STOCK < 0) {
    return res.status(400).json({ message: "Invalid input" });
  }
  try {
    await sql.connect(config);
    await sql.query`
      INSERT INTO PRODUCTS (PRODUCTNAME, PRICE, STOCK)
      VALUES (${PRODUCTNAME}, ${PRICE}, ${STOCK})
    `;
    res.status(201).json({ message: "Product created" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateProduct = async (req, res) => {
  const id = req.params.id;
  const { PRODUCTNAME, PRICE, STOCK } = req.body;
  try {
    await sql.connect(config);
    const result = await sql.query`
      UPDATE PRODUCTS
      SET PRODUCTNAME = ${PRODUCTNAME}, PRICE = ${PRICE}, STOCK = ${STOCK}
      WHERE PRODUCTID = ${id}
    `;
    res.json({ message: "Product updated" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.deleteProduct = async (req, res) => {
  const id = req.params.id;
  try {
    await sql.connect(config);
    await sql.query`DELETE FROM PRODUCTS WHERE PRODUCTID = ${id}`;
    res.json({ message: "Product deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
