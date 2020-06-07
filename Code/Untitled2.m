clc
clf
clear all
workspace = [2 2 2 2 -1 1];
handLoc = transl(1.5, 0.3, 0.4);
[handMesh, VertexCount, Verts] = PlotCutlery('hand2.ply', handLoc(1,4), handLoc(2,4), handLoc(3,4));
handMesh_h = handMesh;
handVerts = Verts;
handVertexCount = VertexCount;
%
handFaceNormals = zeros(size(handMesh_h.Faces,1),3);
    for faceIndex = 1:size(handMesh_h.Faces,1)
        v1 = handMesh_h.Vertices(handMesh_h.Faces(faceIndex,1)',:);
        v2 = handMesh_h.Vertices(handMesh_h.Faces(faceIndex,2)',:);
        v3 = handMesh_h.Vertices(handMesh_h.Faces(faceIndex,3)',:);
        handFaceNormals(faceIndex,:) = unit(cross(v2-v1,v3-v1));
    end

for z = 0.2:0.05:0.5
    line('XData', [0.6 1.8], 'YData', [0.7 0.7], 'Zdata', [z z], 'Color', [0 1 0]);
    
end

    startPoints = [];
    for x = 0.6:0.1:1.2
        for y = 0.7
            for z = 0.2:0.05:0.35
                startPoints = [startPoints; x y z];
            end
            
        end
        
    end
    
    finishPoints = [];
    for x = 1.2:0.1:1.8
        for y = 0.7
            for z = 0.35:0.05:0.5
                finishPoints = [finishPoints; x y z];
            end
            
        end
        
    end
   


%%
% Move forwards (facing in -y direction)
%forwardTR = transl(0,0.02,0);
steps = 10;
handPose = handLoc;

forwardTR = makehgtform('translate',[0,0.05,0]);
%forwardTR = transl(1.5, 0.7, 0);
for i = 1:steps
    
    % Move forward then random rotation
    handPose = handPose*forwardTR;
    % Transform the vertices
    updatedPoints = [handPose * [handVerts,ones(handVertexCount,1)]']';
    lightCurtainStatus = LaserCollision(startPoints, finishPoints, handMesh_h.Vertices, handMesh_h.Faces, handFaceNormals); 
    if lightCurtainStatus == 1
      display('Collision Detected!!! Robot has paused');
      while lightCurtainStatus == 1
      pause(0.1);
      return
      end

    else
        display('No collisions: Cutlery Magician safely moving~');
%         return
    end
    % Update the mesh vertices in the patch handle
    handMesh_h.Vertices = updatedPoints(:,1:3);
    drawnow();   
end
