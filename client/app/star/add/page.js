"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import api from "@/lib/api"; // Импортируем настроенный экземпляр Axios

export default function AddStar() {
  const [name, setName] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(null);
  const router = useRouter();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setSuccess(null);

    try {
      const res = await api.post("/stars", { name, password }); // Используем api.post вместо fetch
      setSuccess(`Star created successfully with ID: ${res.data.id}`);
      setName("");
      setPassword("");
      router.push(`/star/${res.data.id}`);
    } catch (err) {
      setError(err.response?.data?.error || "Failed to create star");
    }
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen py-2">
      <h1 className="text-4xl font-bold">Add a Star</h1>
      <form onSubmit={handleSubmit} className="mt-4 w-full max-w-md">
        <div className="mb-4">
          <label htmlFor="name" className="block text-lg font-medium">
            Name
          </label>
          <input
            type="text"
            id="name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            className="w-full px-4 py-2 border rounded"
            required
          />
        </div>
        <div className="mb-4">
          <label htmlFor="password" className="block text-lg font-medium">
            Password
          </label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full px-4 py-2 border rounded"
            required
          />
        </div>
        <button
          type="submit"
          className="w-full px-4 py-2 text-white bg-blue-500 rounded hover:bg-blue-600"
        >
          Add Star
        </button>
      </form>
      {error && <p className="mt-4 text-red-500">{error}</p>}
      {success && <p className="mt-4 text-green-500">{success}</p>}
    </div>
  );
}