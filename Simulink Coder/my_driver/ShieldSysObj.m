classdef ShieldSysObj < matlab.System & coder.ExternalDependency
    %
    % Testing a simple STM32 device driver
    % 
    
    % Copyright 2016-2024 The MathWorks, Inc.
    %#codegen
    %#ok<*EMCA>
    
    properties
        % Public, tunable properties.
    end
    
    properties (Nontunable)
        % Public, non-tunable properties.
    end
    
    properties (Access = private)
        % Pre-computed constants.
    end
    
    methods
        % Constructor
        function obj = ShieldSysObj(varargin)
            % Support name-value pair arguments when constructing the object.
            setProperties(obj,nargin,varargin{:});
        end
    end
    
    methods (Access=protected)
        function setupImpl(obj) %#ok<MANU>
            if isempty(coder.target)
                % Place simulation setup code here
            else
                % Call C-function implementing device initialization
                coder.cinclude('BlinkWrapper.h');
                coder.ceval('ShieldWrapper_Init');
            end
        end
        
        function stepImpl(obj,u, mode)  %#ok<INUSD>
            if isempty(coder.target)
                % Place simulation output code here 
            else
                % Call C-function implementing device output
                coder.ceval('ShieldWrapper_Step', u, mode);
            end
        end
        
        function releaseImpl(obj) %#ok<MANU>
            if isempty(coder.target)
                % Place simulation termination code here
            else
                % Call C-function implementing device termination
                %coder.ceval('sink_terminate');
            end
        end
    end
    
    methods (Access=protected)
        %% Define input properties
        function num = getNumInputsImpl(~)
            num = 2;
        end
        
        function num = getNumOutputsImpl(~)
            num = 0;
        end
        
        function flag = isInputSizeMutableImpl(~,~)
            flag = false;
        end
        
        function flag = isInputComplexityMutableImpl(~,~)
            flag = false;
        end
        
        function validateInputsImpl(~, u, mode)
            if isempty(coder.target)
                % Run input validation only in Simulation
                validateattributes(u,{'double'},{'scalar'},'','u');
                validateattributes(mode, {'int32'}, {'scalar'}, '', 'mode');
                
            end
        end
        
        function icon = getIconImpl(~)
            % Define a string as the icon for the System block in Simulink.
            icon = 'Motor Shield';
        end
    end
    
    methods (Static, Access=protected)
        function simMode = getSimulateUsingImpl(~)
            simMode = 'Interpreted execution';
        end
        
        function isVisible = showSimulateUsingImpl
            isVisible = false;
        end
    end
    
    methods (Static)
        function name = getDescriptiveName(~)
            name = 'Sink';
        end
        
        function tf = isSupportedContext(~)
            tf = true;
        end
        
        function updateBuildInfo(buildInfo, context)
            % Update buildInfo
            if context.isCodeGenTarget('rtw')
                % Update buildInfo
                srcDir = fullfile(fileparts(mfilename('fullpath')),'src');
                includeDir = fullfile(fileparts(mfilename('fullpath')),'include');
                libDir =  fullfile(fileparts(mfilename('fullpath')),'libraries');
    
                % Include header files
                addIncludePaths(buildInfo,includeDir);
                addIncludePaths(buildInfo,libDir);
    
                % Include source files
                addSourceFiles(buildInfo,'ShieldWrapper.cpp',srcDir);
                addSourceFiles(buildInfo,'ShieldArduino.cpp',libDir);
    
        
                % Add SPI Library - For AVR Based
                ideRootPath = arduino.supportpkg.getAVRRoot;
                addIncludePaths(buildInfo, fullfile(ideRootPath, 'packages', 'arduino', 'hardware', 'avr', '1.8.3','libraries','SPI','src'));
                srcFilePath = fullfile(ideRootPath, 'packages', 'arduino', 'hardware', 'avr', '1.8.3','libraries','SPI','src');
                
                fileNameToAdd = {'SPI.cpp'};
                addSourceFiles(buildInfo, fileNameToAdd, srcFilePath);
        
                % Add Wire / I2C Library - For AVR Based
                addIncludePaths(buildInfo, fullfile(ideRootPath, 'packages', 'arduino', 'hardware', 'avr', '1.8.3','libraries', 'Wire', 'src'));
                addIncludePaths(buildInfo, fullfile(ideRootPath, 'packages', 'arduino', 'hardware', 'avr', '1.8.3','libraries', 'Wire', 'src', 'utility'));

                srcFilePath = fullfile(ideRootPath, 'packages', 'arduino', 'hardware', 'avr', '1.8.3','libraries', 'Wire', 'src');
                fileNameToAdd = {'Wire.cpp'};
                addSourceFiles(buildInfo, fileNameToAdd, srcFilePath);

                srcFilePath = fullfile(ideRootPath, 'packages', 'arduino', 'hardware', 'avr', '1.8.3','libraries', 'Wire', 'src', 'utility');
                fileNameToAdd = {'twi.c'};
                addSourceFiles(buildInfo, fileNameToAdd, srcFilePath);
            end
         end
    end
end
