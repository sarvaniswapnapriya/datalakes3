const AWS = require('aws-sdk');
const fs = require('fs');

const s3 = new AWS.S3({
  region: 'eu-north-1',
});

const bucketName = 'coderabbit-s3-data-lake-demo';
const rawDataFile = 'customer_data.csv';
const processedDataFile = 'sales_data.parquet';

async function uploadFile(fileName, key) {
  const fileContent = fs.readFileSync(fileName);

  const params = {
    Bucket: bucketName,
    Key: key,
    Body: fileContent,
    ACL: 'private',
  };

  try {
    const data = await s3.upload(params).promise();
    console.log(`File uploaded successfully: ${data.Location}`);
  } catch (err) {
    console.error('Error uploading file:', err); 
  }
}

uploadFile(rawDataFile, 'raw_data/customer_data.csv');

uploadFile(processedDataFile, 'processed_data/sales_data.parquet');
