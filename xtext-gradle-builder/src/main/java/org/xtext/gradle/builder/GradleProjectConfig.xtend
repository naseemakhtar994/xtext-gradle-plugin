package org.xtext.gradle.builder

import org.eclipse.emf.common.util.URI
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.util.UriUtil
import org.eclipse.xtext.workspace.IProjectConfig
import org.eclipse.xtext.workspace.ISourceFolder
import org.xtext.gradle.protocol.GradleBuildRequest
import org.eclipse.xtext.workspace.SingleProjectWorkspaceConfig

@FinalFieldsConstructor
class GradleProjectConfig implements IProjectConfig {
	val GradleBuildRequest request

	override getName() {
		request.projectName
	}

	override getPath() {
		UriUtil.createFolderURI(request.projectDir)
	}

	override getSourceFolders() {
		request.sourceFolders.map [
			val uri = UriUtil::createFolderURI(it)
			new GradleSourceFolder(this, uri)

		].toSet
	}

	override findSourceFolderContaining(URI member) {
		sourceFolders.findFirst[UriUtil::isPrefixOf(path, member)]
	}
	
	override getWorkspaceConfig() {
		new SingleProjectWorkspaceConfig(this)
	}
	
}

@FinalFieldsConstructor
class GradleSourceFolder implements ISourceFolder {
	val GradleProjectConfig parent
	@Accessors
	val URI path

	override getName() {
		path.deresolve(parent.path).trimSegments(1).path
	}
}
