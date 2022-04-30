package com.storage.aws.app.usecases;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.storage.aws.app.infra.StorageProvider;
import com.storage.aws.app.infra.utils.StorageUtils;

@Service
public class FileUploadUsecase implements UsecaseService<MultipartFile, Boolean> {
	
	@Autowired
	private StorageProvider storage;
	
	@Override
	public Boolean apply(MultipartFile file) {
		try {
			String randomName = StorageUtils.generateRandomFilename(file);
			storage.save("/upload",randomName , file.getInputStream());
			 return true;
		} catch (IOException e) {
			throw new UseCaseException(e.getMessage());
		}
	}
			
}
