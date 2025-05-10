"use client";

import { useSearchParams } from "next/navigation";

const Welcome = () => {
  const searchParams = useSearchParams();
  const key = searchParams.get("key");

  return (
    <div className="flex flex-col items-center justify-center min-h-screen py-2">
      <h1 className="text-4xl font-bold mb-4">Welcome</h1>
      <p className="text-lg">Your access key:</p>
      <code className="bg-gray-100 p-2 rounded text-blue-600 font-mono text-lg">
        {key}
      </code>
    </div>
  );
};

export default Welcome;
