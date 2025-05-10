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
      const response = await axios.post("/login", {
        key,
        password,
      });

      localStorage.setItem("token", response.data.token);

      router.push("/dashboard");
    } catch (err) {
      setError(err.response?.data?.error || "Error.");
    }
  };

  return (
    <div>
      <h1>Login</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Key:</label>
          <input
            type="text"
            value={key}
            onChange={(e) => setKey(e.target.value)}
            required
          />
        </div>
        <div>
          <label>Password:</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        {error && <p style={{ color: "red" }}>{error}</p>}
        <button type="submit">Send</button>
      </form>
    </div>
  );
};

export default Login;