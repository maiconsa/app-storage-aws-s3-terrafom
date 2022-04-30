package com.storage.aws.app.usecases;

import java.io.OutputStream;

public class DownloadObjectRequest<T extends OutputStream > {
	private T target;
	private String name;
	public DownloadObjectRequest(T target, String name) {
		super();
		this.target = target;
		this.name = name;
	}
	public T getTarget() {
		return target;
	}
	public String getName() {
		return name;
	}
	
	
	
}
