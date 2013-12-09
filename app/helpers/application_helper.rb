# Author: Damien
module ApplicationHelper
    def javascript(*files)
        content_for(:head) { javascript_include_tag(*files) 
        }
    end

    def dictionary
      BzinbergJiangtydYczLapentabFinal::Application.DICTIONARY
    end
end
