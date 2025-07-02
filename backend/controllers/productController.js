const sql = require("mssql");
const config = require("../db/config");

exports.getAllProducts = async (req, res) => {
  const { page = 1, limit = 10, search = '', sort = '' } = req.query;


  const pageNum = Math.max(1, parseInt(page, 10) || 1);
  const limitNum = Math.max(1, parseInt(limit, 10) || 10);
  const offset = (pageNum - 1) * limitNum;

  try {
    const pool = await sql.connect(config);

    let whereClause = '';
    let orderByClause = '';

    const searchParam = search ? `%${search}%` : '%';

    if (search) {
      whereClause = `WHERE PRODUCTNAME LIKE @search`;
    }

   
    const validSortColumns = ['price', 'stock'];
    orderByClause = validSortColumns.includes(sort.toLowerCase())
      ? `ORDER BY ${sort.toUpperCase()}`
      : `ORDER BY PRODUCTID DESC`;

    
    const query = `
      SELECT COUNT(*) AS total FROM PRODUCTS ${whereClause};
      SELECT * FROM PRODUCTS ${whereClause} ${orderByClause} OFFSET ${offset} ROWS FETCH NEXT ${limitNum} ROWS ONLY;
    `;
    

    const result = await pool.request()
      .input('search', sql.NVarChar, searchParam)
      .query(query);

    const totalItems = result.recordsets[0][0].total;
    const products = result.recordsets[1];

    res.json({
      products,
      pagination: {
        totalItems,
        currentPage: pageNum,
        totalPages: Math.ceil(totalItems / limitNum),
      },
    });
  } catch (err) {
    console.error('Error:', err);
    res.status(500).json({ error: 'Internal server error' });
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
