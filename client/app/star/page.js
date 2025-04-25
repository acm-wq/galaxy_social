"use client";

import { useEffect, useState } from "react";
import Cookies from "js-cookie";
import api from "@/lib/api";

export default function Star() {
  const [star, setStar] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchRandomStar = async () => {
    setLoading(true);
    setError(null);

    try {
      const viewedStarNames = JSON.parse(Cookies.get("viewed_stars") || "[]");

      const res = await api.get("/stars/random", {
        params: { list_stars: viewedStarNames },
      });

      if (res.data?.name) {
        setStar(res.data);

        const updatedViewedStars = [...viewedStarNames, res.data.name];
        Cookies.set("viewed_stars", JSON.stringify(updatedViewedStars), { expires: 1 });
      } else {
        console.error("Invalid star data:", res.data);
        setError("Incorrect star data.");
      }
    } catch (err) {
      if (err.response?.status === 404) {
        setError("No star found. Please try again.");
      } else {
        setError("Error fetching star. Please try again.");
      }
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

      {loading ? (
        <p className="text-lg">Loading...</p>
      ) : star ? (
        <div className="shadow-xl rounded-2xl p-6 w-full max-w-md text-center">
          <img src={star.avatar} alt={star.name} className="w-86 h-86 rounded-full" />
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
