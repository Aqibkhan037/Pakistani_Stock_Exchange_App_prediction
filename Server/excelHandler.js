const ExcelJS = require('exceljs');
const fs = require('fs');
const path = require('path');

// Method to read Excel file from directory and extract Date and Close columns
const readExcelFile = async () => {
  try {
    // Assuming the Excel file is named 'data.xlsx' and located in the 'excel' directory
    const excelFilePath = path.join(__dirname,'KSE-100.xlsx');
    
    // Check if the file exists
    if (!fs.existsSync(excelFilePath)) {
      throw new Error('Excel file not found');
    }

    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.readFile(excelFilePath);

    const worksheet = workbook.getWorksheet(1); // Assuming data is in the first worksheet
    const dates = [];
    const closes = [];

    worksheet.eachRow((row, rowNumber) => {
      if (rowNumber > 1) { // Skip header row
        dates.push(row.getCell(1).value); // Assuming Date is in the first column (A)
        closes.push(row.getCell(5).value); // Assuming Close is in the second column (B)
      }
    });

    return { dates, closes };
  } catch (error) {
    throw error;
  }
};

module.exports = {
  readExcelFile
};
