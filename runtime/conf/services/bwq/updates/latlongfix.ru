# Remove spurious lat/longs from baseline graph only
DELETE WHERE {
    GRAPH <http://localhost/dms/metadata/bwq/graph/baseline> {
        ?s <http://www.w3.org/2003/01/geo/wgs84_pos#long> ?o
    }
};
DELETE WHERE {
    GRAPH <http://localhost/dms/metadata/bwq/graph/baseline> {
        ?s <http://www.w3.org/2003/01/geo/wgs84_pos#lat> ?o
    }
};
# Also remove dangling Bathing water descriptions
DELETE WHERE {
    GRAPH <http://localhost/dms/metadata/bwq/graph/baseline> {
        ?bw a <http://environment.data.gov.uk/def/bathing-water/BathingWater>;
            ?p ?o.
    }    
}
