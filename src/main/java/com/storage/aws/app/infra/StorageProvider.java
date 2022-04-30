package com.storage.aws.app.infra;

import java.io.InputStream;
import java.util.Map;

public interface StorageProvider  {
	public void save(String path,String fileName, InputStream inputStream);
	public StorageObject read(String path);
	public void remove(String path) ;
	
	
	public static class StorageObject{
		private String name;
		private String relativepath;
		private String fullpath;
		private InputStream inputStream;
		private Map<String, Object> metadados;
		
		public StorageObject(String name, String relativepath, String fullpath, InputStream inputStream,
				Map<String, Object> metadados) {
			super();
			this.name = name;
			this.relativepath = relativepath;
			this.fullpath = fullpath;
			this.inputStream = inputStream;
			this.metadados = metadados;
		}
		public String getName() {
			return name;
		}
		public String getRelativepath() {
			return relativepath;
		}
		public String getFullpath() {
			return fullpath;
		}
		public InputStream getInputStream() {
			return inputStream;
		}
		public Map<String, Object> getMetadados() {
			return metadados;
		}
		
		
	}
}
