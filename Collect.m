function Collect(nameObject)
    cao = webcam
    faceDetector = vision.CascadeObjectDetector;
    c=50;
    f=figure('Name','Thu Thap Du Lieu');
    cd('DataCollect')
    status = mkdir(string(nameObject));
    if (status ==1)  
        cd(nameObject);
    else 
        return ;
    end
    f.Position(3:4) = [280 210];
    temp=0;
    while true 
        e = cao.snapshot;
        bboxes = step(faceDetector,e);
        if(sum(sum(bboxes)) ~= 0)
            if(temp >=c)
                break;
            else
         es=imcrop(e, bboxes(1,:));
         es= imresize(es,[227 227]);
         filename= strcat(num2str(temp),'.bmp');
         imwrite(es,filename);
         temp=temp+1;
         imshow(es);
         drawnow;
            end
        else 
           imshow(e);
           drawnow;
        end
    end
    close(f);
    cd('..\..')
end
