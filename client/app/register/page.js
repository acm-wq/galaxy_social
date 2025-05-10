"use client";

import { useState } from "react";
import axios from "../../lib/api";
import { useRouter } from "next/navigation";

const Register = () => {
  const [name, setName] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const router = useRouter();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setSuccess("");

    try {
      const response = await axios.post("/register", {
        name,
        password,
      });

      setSuccess("Success!");
      setName("");
      setPassword("");

      router.push("/login");
    } catch (err) {
      setError(err.response?.data?.error || "Error.");
    }
  };

  return (
    <div>
      <h1>register</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Name:</label>
          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
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
        {success && <p style={{ color: "green" }}>{success}</p>}
        <button type="submit">Send</button>
      </form>
    </div>
  );
};

export default Register;