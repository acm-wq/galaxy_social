"use client";

import { useEffect, useState } from "react";
import api from "@/lib/api";

export default function Star() {
  const [star, setStar] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchRandomStar = async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await api.get("/stars/random");
      setStar(res.data);
    } catch (err) {
      setError("No star found");
      setStar(null);
      console.error("Error fetching star:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchRandomStar();
  }, []);

  return (
    <div className="flex flex-col items-center justify-center min-h-screen py-10 px-4">
      <h1 className="text-4xl font-bold mb-6">🌟</h1>

      {loading ? (
        <p className="text-lg">Loading...</p>
      ) : star ? (
        <div className="shadow-xl rounded-2xl p-6 w-full max-w-md text-center">
          <h2 className="text-2xl font-semibold mb-2">{star.name}</h2>
        </div>
      ) : (
        <p className="text-lg text-red-500">{error || "No star found"}</p>
      )}

      <button
        className="mt-6 px-6 py-2 text-white bg-blue-500 hover:bg-blue-700 rounded"
        onClick={fetchRandomStar}
      >
        Next
      </button>
    </div>
  );
}
