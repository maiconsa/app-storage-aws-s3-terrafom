package com.storage.aws.app.usecases;

import java.io.IOException;
import java.io.OutputStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.util.IOUtils;
import com.storage.aws.app.infra.StorageProvider;
import com.storage.aws.app.infra.StorageProvider.StorageObject;

@Service
public class TransferStorageObjectUsecase implements UsecaseService<DownloadObjectRequest<OutputStream>, StorageObject> {
			
	@Autowired
	StorageProvider storage;
	
	@Autowired
	AmazonS3Client client;
	
	@Value("${storage.s3.bucket-name}") 
	private String bucketName;
	
	@Override
	public StorageObject apply(DownloadObjectRequest<OutputStream> request) {
		
		try {
			String fullpath = client.getUrl(bucketName, "upload/".concat(request.getName())).toExternalForm();
			StorageObject object = storage.read(fullpath);
			IOUtils.copy(object.getInputStream(), request.getTarget());
			return object;
		} catch (IOException e) {
			throw new UseCaseException(e.getMessage());
		}	
	}
}
