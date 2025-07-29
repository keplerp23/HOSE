// Wait for the DOM to be fully loaded
document.addEventListener("DOMContentLoaded", function () {
  const tableContainer = document.getElementById("tableContainer");
  const searchBox = document.getElementById("searchBox");

  // Fetch the first 20 rows from your local R API
  fetch("http://127.0.0.1:8000/data?limit=20")
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok: " + response.statusText);
      }
      return response.json();
    })
    .then(data => {
      if (!Array.isArray(data) || data.length === 0) {
        throw new Error("No data returned from API.");
      }

      console.log("Data fetched from API:", data);

      // Build column structure from keys
      const columns = Object.keys(data[0]).map(key => ({
        title: key,
        data: key
      }));

      // Initialize DataTable
      const table = $('#statsTable').DataTable({
        data: data,
        columns: columns,
        paging: true,
        scrollX: true
      });

      // Live search via searchBox
      searchBox.addEventListener("keyup", function () {
        table.search(this.value).draw();
      });
    })
    .catch(error => {
      console.error("Error loading data:", error);
      tableContainer.innerHTML = `<p style="color: red;">Error loading data: ${error.message}</p>`;
    });
});
