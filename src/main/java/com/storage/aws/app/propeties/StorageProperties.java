package com.storage.aws.app.propeties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties("storage")
public class StorageProperties {
	
	private S3 s3;
	
	public S3 getS3() {
		return s3;
	}

	public void setS3(S3 s3) {
		this.s3 = s3;
	}

	public class S3{
		private String bucketName;
		public S3() {
		}
		public String getBucketName() {
			return bucketName;
		}
		public void setBucketName(String bucketName) {
			this.bucketName = bucketName;
		}
	}
}
