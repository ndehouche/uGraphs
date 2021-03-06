// SPDX-License-Identifier: MIT
// ----------------------------------------------------------------------------
// A Solidity Library for unoriented graphs
// (c) Nassim Dehouche/ forValue.org. MIT Licence.
// ----------------------------------------------------------------------------
pragma solidity >=0.7.0 <0.9.0;
library uGraphs{

event nodeAdded(uint _index);
event edgeAdded(uint _index1, uint _index2);
event nodeDeleted(uint _index);
event edgeDeleted(uint _index1, uint _index2);

    


struct Node {
    uint value;
    uint[] neighbors;
    // Only Neighbors with indices lower than that of the current node  
    }


struct Graph {
    uint nodeCount;
    uint last;
    uint edgeCount;
    Node deleted;
    // Node outside the graph, pointed by deleted indices
    mapping(uint => Node) nodes;
    }

 function max(uint[] memory _neighbors) internal pure returns (uint _max) {
        _max = _neighbors[0];
        for(uint i;i < _neighbors.length;i++){
            if(_neighbors[i] > _max){
                _max = _neighbors[i];
            }
        }
        
    }
    
function addNode(Graph storage G, uint _value, uint[] memory _neighbors) internal returns (uint _index) {
    require(max(_neighbors)<G.nodeCount || G.nodeCount==0 );
    G.nodes[G.last] = Node({
    value: _value,
    neighbors: _neighbors
    });
    _index=G.nodeCount;
    G.nodeCount++;
    G.edgeCount+=_neighbors.length;
    G.last++;
    emit nodeAdded(G.nodeCount);
    }

function addEdge(Graph storage G, uint _index1, uint _index2) internal returns (bool _done) {
    require(_index1<G.nodeCount && _index2<G.nodeCount && _index1<_index2);
    G.nodes[_index1].neighbors.push(_index2); 
    G.edgeCount++;
    _done=true;
    emit edgeAdded(_index1, _index2);
    }
function isEdge(Graph storage G, uint _index1, uint _index2) internal view returns (uint _index) {
    uint i;
    while (i<G.nodes[_index1].neighbors.length && G.nodes[_index1].neighbors[i]!=_index2)
    {i++;}
    _index=i;
    }
function isNode(Graph storage G, uint _index) internal view returns (bool _isNode) {
    _isNode=(keccak256(abi.encodePacked(G.nodes[_index].value))!=keccak256(abi.encodePacked(G.deleted.value)) && _index<=G.last);
    }
    
function deleteNode(Graph storage G, uint _index) internal returns (bool _done) {
    if(_index<G.last){
    G.nodes[_index]=G.deleted;
    
    for(uint i;i < _index;i++){
    if (isEdge(G,i, _index)<G.nodes[i].neighbors.length){
    deleteEdge(G,i,_index);}
    }
    }
    else{
    G.nodes[_index]=G.deleted;
    uint i=_index;
    while (!isNode(G,i) && i>=0){
    i--;    
    }
    G.last=i;
    for(i=0;i < _index;i++){
    if (isEdge(G,i, _index)<G.nodes[i].neighbors.length){
    deleteEdge(G,i,_index);}
    }    
    }
    emit nodeDeleted(_index);    
    _done=true;
    }
function deleteEdge(Graph storage G, uint _index1, uint _index2) internal returns (bool _done) {
    require(_index1<G.nodeCount && _index2<G.nodeCount && _index1<_index2);
    uint i;
    i=isEdge(G,_index1,_index2);
    if (i<G.nodes[_index1].neighbors.length){
    G.nodes[_index1].neighbors[i]=G.nodes[_index1].neighbors[G.nodes[_index1].neighbors.length-1];
    G.nodes[_index1].neighbors.pop;
    }
    emit edgeDeleted(_index1, _index2); 
    _done=true;
    }
    
}
