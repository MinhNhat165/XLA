function Test()
    figure;
    c = webcam;
    load myNet1;
    faceDetector = vision.CascadeObjectDetector;
    while true 
        e = c.snapshot;
        bboxes = step(faceDetector,e);
        if(sum(sum(bboxes)) ~= 0)
            es=imcrop(e, bboxes(1,:));
            es= imresize(es,[227 227]);
            label = classify(myNet1,es);
            fprintf(char(label));
            image(e);
            title(char(label));
           drawnow;
        else 
            fprintf('No');
            image(e);
            title('No Found Face');
        end
    end
end
