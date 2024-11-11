const AWS = require('aws-sdk');
const fs = require('fs');

// Initialize the S3 client
const s3 = new AWS.S3({
  region: 'eu-north-1',
});

const bucketName = 'coderabbit-s3-data-lake-demo';
const rawDataFile = 'customer_data.csv';
const processedDataFile = 'sales_data.parquet';

// Function to upload file to S3
async function uploadFile(fileName, key) {
  const fileContent = fs.readFileSync(fileName);

  const params = {
    Bucket: bucketName,
    Key: key,
    Body: fileContent,
    ACL: 'private',  // Mistake: ACL should be handled more securely, especially with public access
  };

  try {
    const data = await s3.upload(params).promise();
    console.log(`File uploaded successfully: ${data.Location}`);
  } catch (err) {
    console.error('Error uploading file:', err);  // Mistake: Basic error handling; should use retries or better logging
  }
}

// Upload raw data file (CSV)
uploadFile(rawDataFile, 'raw_data/customer_data.csv');

// Upload processed data file (Parquet)
uploadFile(processedDataFile, 'processed_data/sales_data.parquet');
