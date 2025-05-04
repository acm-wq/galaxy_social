'use client'

import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import api from "@/lib/api";
import { use } from "react";

async function getStar(id) {
  try {
    const res = await api.get(`/stars/${id}`);
    return res.data;
  } catch (error) {
    if (error.response?.status === 404) {
      throw new Error("Star not found");
    }
    throw new Error("Failed to fetch star");
  }
}

export default function StarPage({ params }) {
  const { id } = use(params);
  const router = useRouter();

  const [star, setStar] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    getStar(id)
      .then(setStar)
      .catch((err) => setError(err.message));
  }, [id]);

  const handleAddPlanet = () => {
    router.push(`/star/${id}/planet/new`);
  };

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen py-2">
        <h1 className="text-4xl font-bold">Error</h1>
        <p className="mt-4 text-lg">{error}</p>
      </div>
    );
  }

  if (!star) {
    return (
      <div className="flex items-center justify-center min-h-screen py-2">
        <p>Loading...</p>
      </div>
    );
  }

  return (
    <div className="flex flex-col items-center justify-center min-h-screen py-2">
      <img src={star.avatar} alt={star.name} className="w-86 h-86 rounded-full" />
      <h1 className="text-4xl font-bold">Star: {star.name}</h1>
      <p className="mt-4 text-lg">Class star: {star.type_star}</p>

      <button
        onClick={handleAddPlanet}
        className="mt-6 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
      >
        Add Planet
      </button>
    </div>
  );
}
