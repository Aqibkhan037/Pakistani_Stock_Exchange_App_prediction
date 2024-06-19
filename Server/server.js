const express = require('express');
const cors = require('cors');
const scrapePSX = require('./scrapePSX');
const fetchIndexData = require('./scrapeIndices'); // Assuming this fetches index data
const { readExcelFile } = require('./excelHandler');

const app = express();
const port = 3000;

// Enable CORS before defining routes
app.use(cors());

app.get('/api/readExcel', async (req, res) => {
  try {
    const data = await readExcelFile();
    res.json(data);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
});
app.get('/api/scrape', async (req, res) => {
    try {
      console.log('server is working');
      const data = await scrapePSX();
      res.json(data);
    } catch (error) {
      console.error(error);  // Log the error for debugging
      res.status(500).json({ error: 'Internal server error', details: error.message });
    }
  });
  

  app.get('/api/indices', async (req, res) => {
    try {
      console.log('Fetching index data...');
      const indexData = await fetchIndexData(); // Replace with actual function call
      res.json(indexData);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error', details: error.message });
    }
  });

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});

//http://localhost:3000/api/indices
//http://localhost:3000/api/scrape