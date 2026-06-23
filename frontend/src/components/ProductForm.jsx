import { useState } from "react";

export default function ProductForm({ onAdd }) {
  const [name, setName] = useState("");
  const [price, setPrice] = useState("");

  const submit = async (e) => {
    e.preventDefault();

    await onAdd({
      name,
      price: Number(price)
    });

    setName("");
    setPrice("");
  };

  return (
    <form onSubmit={submit}>
      <input
        placeholder="Product Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />

      <input
        placeholder="Price"
        value={price}
        onChange={(e) => setPrice(e.target.value)}
      />

      <button type="submit">
        Add Product
      </button>
    </form>
  );
}