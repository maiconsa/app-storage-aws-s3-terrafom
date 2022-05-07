package com.storage.aws.app.infra.impl;

import java.io.InputStream;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.util.StringUtils;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.S3Object;
import com.storage.aws.app.infra.SearchStorageProvider;
import com.storage.aws.app.infra.StorageProvider;
import com.storage.aws.app.infra.utils.StorageUtils;

public class S3StorageProvider implements StorageProvider,SearchStorageProvider {
	private AmazonS3Client client;
	private String bucketName;
	public S3StorageProvider(AmazonS3Client client,String bucketName) {
		this.client = client;
		this.bucketName = bucketName;
	}
	
	@Override
	public StorageObject read(String fullpath) {
		String key = StorageUtils.S3.getKeyFileLocation(fullpath);
		 S3Object object = this.client.getObject(bucketName, key);	
		 String name = StringUtils.getFilename(key);
		return new StorageObject(name, object.getKey(),fullpath, object.getObjectContent(), null) ;
	}
	
	@Override
	public void remove(String path) {
		String key = StorageUtils.S3.getKeyFileLocation(path);
		this.client.deleteObject(bucketName, key);
		
	}
	@Override
	public void save(String path, String fileName, InputStream inputStream) {
		String normalizePath  = path.replaceFirst("/", "");
		String key = Paths.get(normalizePath).resolve(fileName).toString();
		
		this.client.putObject(this.bucketName, key, inputStream, new ObjectMetadata());
		
	}
	
	public List<ObjectSummary> search(String path){
		return  this.client.listObjectsV2(bucketName, path ).getObjectSummaries().stream()
		.map(objectSummary -> new ObjectSummary(StringUtils.getFilename(objectSummary.getKey()), 
							objectSummary.getKey() ,
							client.getUrl(bucketName, objectSummary.getKey()).toString(),
							objectSummary.getLastModified()
							))
		.collect(Collectors.toList());
	}
	
	
	
	
}
