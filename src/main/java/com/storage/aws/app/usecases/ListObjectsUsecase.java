package com.storage.aws.app.usecases;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.storage.aws.app.infra.SearchStorageProvider;
import com.storage.aws.app.infra.SearchStorageProvider.ObjectSummary;

@Service
public class ListObjectsUsecase implements UsecaseService<String, List<ObjectSummary>> {

	@Autowired
	private SearchStorageProvider searchStorage;
	
	@Override
	public List<ObjectSummary> apply(String folderPath) {
		return searchStorage.search(folderPath);
	}
	
}
