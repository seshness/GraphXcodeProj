import Foundation
import XcodeProj

struct XGNode {
  let type: String
  let id: String
  let name: String?
}

struct XGEdge {
  let sourceId: String
  let destinationId: String
}

class XcodeGraph {
  public private(set) var nodes: [XGNode] = []
  public private(set) var edges: [XGEdge] = []

  init(xcodeproj: XcodeProj) {
    parseXcodeProj(xcodeproj: xcodeproj)
  }

  private func parseXcodeProj(xcodeproj: XcodeProj) {
    let pbxproj = xcodeproj.pbxproj
    
    pbxproj.projects.forEach {
      let uuid = $0.uuid
      self.nodes.append(XGNode(type: type(of: $0).isa, id: uuid, name: $0.name))
      self.edges.append(XGEdge(sourceId: uuid, destinationId: $0.buildConfigurationList.uuid))
      $0.targets.forEach { target in
        self.edges.append(XGEdge(sourceId: uuid, destinationId: target.uuid))
      }
    }

    pbxproj.configurationLists.forEach {
      let uuid = $0.uuid
      self.nodes.append(XGNode(type: type(of: $0).isa, id: uuid, name: nil))
      $0.buildConfigurations.forEach { buildConfiguration in
        self.edges.append(XGEdge(sourceId: uuid, destinationId: buildConfiguration.uuid))
      }
    }
    
    pbxproj.buildConfigurations.forEach {
      let uuid = $0.uuid
      self.nodes.append(XGNode(type: type(of: $0).isa, id: uuid, name: $0.name))
    }
    
    pbxproj.nativeTargets.forEach {
      let uuid = $0.uuid
      self.nodes.append(XGNode(type: type(of: $0).isa, id: uuid, name: $0.name))
      if let buildConfigurationList = $0.buildConfigurationList {
        self.edges.append(XGEdge(sourceId: uuid, destinationId: buildConfigurationList.uuid))
      }
      $0.buildPhases.forEach { buildPhase in
        self.edges.append(XGEdge(sourceId: uuid, destinationId: buildPhase.uuid))
      }
      $0.dependencies.forEach { targetDependency in
        self.edges.append(XGEdge(sourceId: uuid, destinationId: targetDependency.uuid))
      }
    }
    
    pbxproj.buildPhases.forEach {
      let uuid = $0.uuid
      self.nodes.append(XGNode(type: type(of: $0).isa, id: uuid, name: $0.name()))
    }
    
    pbxproj.targetDependencies.forEach {
      let uuid = $0.uuid
      self.nodes.append(XGNode(type: type(of: $0).isa, id: uuid, name: $0.name))
      if let target = $0.target {
        self.edges.append(XGEdge(sourceId: uuid, destinationId: target.uuid))
      }
      if let targetProxy = $0.targetProxy {
        self.edges.append(XGEdge(sourceId: uuid, destinationId: targetProxy.uuid))
      }
    }
    
    pbxproj.containerItemProxies.forEach {
      let uuid = $0.uuid
      self.nodes.append(XGNode(type: type(of: $0).isa, id: uuid, name: $0.remoteInfo))
      if let containerPortalUuid = $0.containerPortal.uuid {
        self.edges.append(XGEdge(sourceId: uuid, destinationId: containerPortalUuid))
      }
      if let remoteGlobalID = $0.remoteGlobalID {
        self.edges.append(XGEdge(sourceId: uuid, destinationId: remoteGlobalID.uuid))
      }
    }
    
    pbxproj.aggregateTargets.forEach {
      let uuid = $0.uuid
      self.nodes.append(XGNode(type: type(of: $0).isa, id: uuid, name: $0.name))
      if let buildConfigurationList = $0.buildConfigurationList {
        self.edges.append(XGEdge(sourceId: uuid, destinationId: buildConfigurationList.uuid))
      }
      $0.buildPhases.forEach { buildPhase in
        self.edges.append(XGEdge(sourceId: uuid, destinationId: buildPhase.uuid))
      }
    }
  }

}
