function varargout = main(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% add logo
global loopFlag;
loopFlag = true;
axes(handles.logo)
logo = imread('D:\xla\Project\assets\Images\logo.jpg');
imshow(logo)

handles.output = hObject;
handles.cam = webcam;
imWidth=1080;
imHeight=720;
axes(handles.camera)
handles.hImage=image(zeros(imHeight,imWidth,1),'Parent',handles.camera);
preview(handles.cam, handles.hImage)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in collect.
function collect_Callback(hObject, eventdata, handles)
prompt  = {'Ten doi tuong'};
title = 'Input';
dism = [1 50];
opts.Interpreter = 'tex';
data = inputdlg(prompt, title, dism, {''}, opts);
nameObject = data{1};
anwser = ''
if(isempty(nameObject))
    warndlg('Vui long nhap ten doi tuong')
else 
    cam = handles.cam;
    faceDetector = vision.CascadeObjectDetector;
    c=50;
    cd('DataCollect')
    status = mkdir(string(nameObject));
    if (status ==1)  
        cd(nameObject);
    else 
        return ;
    end
    temp=0;
    while true 
        e = cam.snapshot;
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
                percent = floor(100 / c * 1.0 * temp);
                message = strcat('Hoàn thành: ', num2str(percent), ' %');
                set(handles.result, 'string',message);
                drawnow;
            end
        else 
           drawnow;
        end
    end
    cd('..\..');
end


% --- Executes on button press in recognition.
function recognition_Callback(hObject, eventdata, handles)
set(handles.stop, 'enable', 'on');
set(handles.recognition, 'enable', 'off');
set(handles.collect, 'enable', 'off');
set(handles.training, 'enable', 'off');
global loopFlag;
loopFlag = true;
load myNet1;
faceDetector = vision.CascadeObjectDetector;
c = handles.cam;
while true 
    if(loopFlag == false)
        set(handles.result, 'string', '');
        set(handles.recognition, 'enable', 'on');
        set(handles.stop, 'enable', 'off');
        set(handles.collect, 'enable', 'on');
        set(handles.training, 'enable', 'on');
        break;
    else
        e = c.snapshot;
        bboxes = step(faceDetector,e);
        if(sum(sum(bboxes)) ~= 0)
            es=imcrop(e, bboxes(1,:));
            es= imresize(es,[227 227]);
            label = classify(myNet1,es);
            set(handles.result, 'string', char(label), 'foregroundcolor', 'g');
        else 
            set(handles.result, 'string', 'No Found Face', 'foregroundcolor', 'r');
        end
    end
end





% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
closereq();



% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
global loopFlag;
loopFlag = false;


% --- Executes on button press in training.
function training_Callback(hObject, eventdata, handles)
set(handles.result, 'string', 'Training...', 'foregroundcolor', 'r');
set(handles.stop, 'enable', 'off');
set(handles.recognition, 'enable', 'off');
set(handles.collect, 'enable', 'off');
set(handles.training, 'enable', 'off');
pause(1)
Training();
set(handles.result, 'string', 'Hoàn Thành', 'foregroundcolor', 'g');
set(handles.stop, 'enable', 'on');
set(handles.recognition, 'enable', 'on');
set(handles.collect, 'enable', 'on');
set(handles.training, 'enable', 'on');
