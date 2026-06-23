import { useEffect, useState } from "react";

import ProductForm from "./components/ProductForm";
import ProductList from "./components/ProductList";

import {
  getProducts,
  createProduct
} from "./api/productApi";

function App() {
  const [products, setProducts] = useState([]);

  const loadProducts = async () => {
    const data = await getProducts();
    setProducts(data);
  };

  useEffect(() => {
    loadProducts();
  }, []);

  const addProduct = async (product) => {
    await createProduct(product);
    loadProducts();
  };

  return (
    <div>
      <h1>Products Dashboard V1</h1>

      <ProductForm onAdd={addProduct} />

      <ProductList products={products} />
    </div>
  );
}

export default App;
