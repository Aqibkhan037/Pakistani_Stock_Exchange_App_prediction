const puppeteer = require('puppeteer');

async function scrapePSX() {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  try {
    // Navigate to the PSX website
    console.log('Navigating to the PSX website...');
    await page.goto('https://dps.psx.com.pk/');

    // Wait for the table and the dropdown to load
    console.log('Waiting for the table to load...');
    await page.waitForSelector('#DataTables_Table_0 tbody tr');
    console.log('Waiting for the dropdown to load...');
    await page.waitForSelector('#DataTables_Table_0_length select');

    // Select the "All" option from the dropdown
    console.log('Selecting the "All" option from the dropdown...');
    await page.select('#DataTables_Table_0_length select', '-1'); // '-1' represents the "All" option

    // Wait for the table to load with all rows
    console.log('Waiting for the table to load with all rows...');
    await page.waitForSelector('#DataTables_Table_0 tbody tr');

    // Extract data from the table
    const tableData = await page.evaluate(() => {
      const rows = Array.from(document.querySelectorAll('#DataTables_Table_0 > tbody > tr'));
      return rows.map(row => {
        const symbol = row.querySelector('td:nth-child(1) > a > strong').innerText;
        const currentRate = row.querySelector('td:nth-child(6)').innerText;
        const change = row.querySelector('td:nth-child(7)').innerText;
        const changePercentage = row.querySelector('td:nth-child(8)').innerText;
        
        console.log({ symbol, currentRate, change, changePercentage });
        return { symbol, currentRate, change, changePercentage };
      });
    });
  
    return tableData;
  } finally {
    await browser.close();
  }
}

module.exports = scrapePSX;



