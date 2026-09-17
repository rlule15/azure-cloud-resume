const functionApiUrl = "/api/GetVisitorCount";

async function getVisitCount() {
  const counterElement = document.getElementById("counter");
  try {
    const response = await fetch(functionApiUrl);
    if (!response.ok) {
      throw new Error(`HTTP status: ${response.status}`);
    }

    const data = await response.json();
    console.log("Visitor count:", data.visitors);

    counterElement.innerText = data.visitors;
  } catch (err) {
    console.warn("Counter API unavailable or not yet configured:", err);
    counterElement.innerText = "1";
  }
}

document.addEventListener("DOMContentLoaded", getVisitCount);
