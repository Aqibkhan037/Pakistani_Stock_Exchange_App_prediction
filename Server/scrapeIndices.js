const puppeteer = require('puppeteer');

async function scrapePSXIndices() {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  try {
    // Navigate to the PSX website
    console.log('Navigating to the PSX website...');
    await page.goto('https://dps.psx.com.pk/');

    // Wait for the tab panel with market indices details to load
    console.log('Waiting for market indices details to load...');
    await page.waitForSelector('.marketIndices__details.tabs__panel--selected');

    // Extract data from the tab panel
    const indicesData = await page.evaluate(() => {


      const tabPanel = document.querySelector('.marketIndices__details.tabs__panel--selected');
      
      const name = tabPanel.getAttribute('data-name');

      const price = tabPanel.querySelector('.marketIndices__price').innerText;
      const change = tabPanel.querySelector('.marketIndices__change').innerText;
      const date = tabPanel.querySelector('.marketIndices__date').innerText;

      const stats = Array.from(tabPanel.querySelectorAll('.stats_item')).map(item => {
        const label = item.querySelector('.stats_label').innerText;
        const value = item.querySelector('.stats_value').innerText;
        return { label, value };
      });

      return { name,price, change, date, stats };
    });

    console.log(indicesData);
    return indicesData;
  } finally {
    await browser.close();
  }
}

module.exports = scrapePSXIndices;
