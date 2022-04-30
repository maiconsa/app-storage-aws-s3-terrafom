package com.storage.aws.app.infra;

import java.util.Date;
import java.util.List;

public interface SearchStorageProvider {
	public List<ObjectSummary> search(String folderPath);
	
	public static class ObjectSummary{
		private String name;
		private String relativepath;
		private String fullpath;	
		private Date lastModified;
		public ObjectSummary(String name, String relativepath, String fullpath, Date lastModificationDate) {
			super();
			this.name = name;
			this.relativepath = relativepath;
			this.fullpath = fullpath;
			this.lastModified  = lastModificationDate;
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
		public Date getLastModified() {
			return lastModified;
		}
		
		
	
	}
}
