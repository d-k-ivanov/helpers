'use strict';

const AWS     = require('aws-sdk');
const S3      = new AWS.S3({ signatureVersion: 'v4'});
const Sharp   = require('sharp');
const BUCKET  = process.env.BUCKET;
const URL     = process.env.URL;

function getImageType(objectContentType) {
  switch (objectContentType) {
    case "image/jpeg":
      return "jpeg";
    case "image/png":
      return "png";
    default:
      throw new Error("Unsupported objectContentType " + objectContentType);
	}
}

exports.handler = function(event, context, callback) {
  const key = event.queryStringParameters.key;
  const match = key.match(/(\d+)x(\d+)\/(.*)/);
  const width = parseInt(match[1], 10);
  const height = parseInt(match[2], 10);
  const originalKey = match[3];

  S3.getObject({Bucket: BUCKET, Key: originalKey}).promise()
    .then(data => Sharp(data.Body)
      .resize(width, height)
      .toFormat(getImageType(data.ContentType))
      .toBuffer()
    )
    .then(buffer => S3.putObject({
        Body: buffer,
        Bucket: BUCKET,
        ContentType: buffer.ContentType,
        Key: key,
      }).promise()
    )
    .then(() => callback(null, {
        statusCode: '301',
        headers: {'location': `${URL}/${key}`},
        body: '',
      })
    )
    .catch(err => callback(err))
}
