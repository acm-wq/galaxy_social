"use client";

import { useState } from "react";
import api from "@/lib/api";
import { useParams } from "next/navigation";

export default function AddPlanet() {
  const { id: star_key } = useParams();
  const [name, setName] = useState("");
  const [type_planet, setTypePlanet] = useState("");
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(null);

  async function handleSubmit(e) {
    e.preventDefault();
    setError(null);
    setSuccess(null);

    try {
      const res = await api.post("/planets", { name, type_planet, star_key: star_key });
      setSuccess(`Planet created successfully`);
      setName("");
      setTypePlanet("");
    } catch (err) {
      setError(err.response?.data?.error || "Failed to create planet");
    }
  }
  return (
    <div className="flex flex-col items-center justify-center min-h-screen py-2">
      <h1 className="text-4xl font-bold">Add a Planet</h1>
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
          <label htmlFor="type_planet" className="block text-lg font-medium">
          Type of Planet
          </label>
          <select
            id="type_planet"
            value={type_planet}
            onChange={(e) => setTypePlanet(e.target.value)}
            className="w-full px-4 py-2 border rounded"
            required
          >
            <option value="" disabled>
              Select a type
            </option>
            <option value="terrestrial">terrestrial</option>
            <option value="gas_giant">gas_giant</option>
            <option value="ice_giant">ice_giant</option>
            <option value="lava">lava</option>
          </select>
        </div>
        {error && <p className="text-red-500">{error}</p>}
        {success && <p className="text-green-500">{success}</p>}
        <button type="submit" className="mt-4 px-6 py-2 bg-blue-500 text-white rounded">
          Add Planet
        </button>
      </form>
    </div>
  );
}
