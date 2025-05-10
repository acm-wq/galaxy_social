"use client";

import { useState } from "react";
import axios from "../../lib/api";
import { useRouter } from "next/navigation";

const Login = () => {
  const [key, setKey] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const router = useRouter();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    try {
      const response = await axios.post("/login", { key, password });
      localStorage.setItem("token", response.data.token);
      router.push("/dashboard");
    } catch (err) {
      setError(err.response?.data?.error || "Error.");
    }
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen py-2">
      <h1 className="text-4xl font-bold">Login</h1>
      <form onSubmit={handleSubmit} className="mt-4 w-full max-w-md">
        <div className="mb-4">
          <label className="block text-lg font-medium">Key</label>
          <input
            type="text"
            value={key}
            onChange={(e) => setKey(e.target.value)}
            className="w-full px-4 py-2 border rounded"
            required
          />
        </div>
        <div className="mb-4">
          <label className="block text-lg font-medium">Password</label>
          <input
            type="password"
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
          Login
        </button>
        {error && <p className="mt-4 text-red-500">{error}</p>}
      </form>
    </div>
  );
};

export default Login;
