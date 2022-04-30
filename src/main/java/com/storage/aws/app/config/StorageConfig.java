package com.storage.aws.app.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.amazonaws.services.s3.AmazonS3Client;
import com.storage.aws.app.infra.StorageProvider;
import com.storage.aws.app.infra.impl.S3StorageProvider;

@Configuration
public class StorageConfig {

	@Bean
	StorageProvider storageProvider(AmazonS3Client amazonS3Client, @Value("${storage.s3.bucket-name}") String bucketName) {
		return new S3StorageProvider(amazonS3Client, bucketName);
	}	
	
}
