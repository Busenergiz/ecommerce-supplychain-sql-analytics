# 📊 End-to-End E-Commerce & Supply Chain Operations Analytics (SQL)

![SQL](https://img.shields.io/badge/Language-SQL-blue.svg)
![Database](https://img.shields.io/badge/RDBMS-PostgreSQL%20%2F%20MySQL-orange.svg)
![Field](https://img.shields.io/badge/Domain-MIS%20%26%20Industrial%20Engineering-green.svg)

An enterprise-level relational database schema and analytical SQL solution designed to bridge **Business Intelligence (MIS)** and **Operations Optimization (Industrial Engineering)**. This project models an end-to-end e-commerce infrastructure, simulating real-world data pipelines across order fulfillment, customer segmentation, inventory control, and logistics performance.

---

## 🏗️ Relational Architecture (ER Diagram Overview)

The database is built on a 3NF-compliant relational model:

* **Core Entities:** `customers`, `products`, `categories`, `suppliers`
* **Transactional Tables:** `orders`, `order_items`
* **Operations & Logistics:** `shipments`, `inventory_logs`

```text
[Suppliers] ---> [Products] <--- [Inventory_Logs]
                     |
                     v
  [Customers] ---> [Orders] ---> [Order_Items] ---> [Shipments]
