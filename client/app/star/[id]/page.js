async function getStar(id) {
  const res = await fetch(`http://localhost:3000/stars/${id}`);
  if (!res.ok) {
    throw new Error("Star not found");
  }
  return res.json();
}

export default async function StarPage({ params }) {
  const { id } = params;

  try {
    const star = await getStar(id);

    return (
      <div className="flex flex-col items-center justify-center min-h-screen py-2">
        <h1 className="text-4xl font-bold">Star: {star.name}</h1>
        <p className="mt-4 text-lg">Key: {id}</p>
      </div>
    );
  } catch (error) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen py-2">
        <h1 className="text-4xl font-bold">Error</h1>
        <p className="mt-4 text-lg">{error.message}</p>
      </div>
    );
  }
}
