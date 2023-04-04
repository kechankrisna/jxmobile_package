local tbAct = Activity:GetClass("CrossEachServerAct")
tbAct.tbTimerTrigger = { }
tbAct.tbTrigger = { Init = { }, Start = { }, End = { }, }
tbAct.nNewInfomationValidTime = 7*24*60*60
function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Init" then
		local szContent = [[
            Liên hệ phục kỹ càng quy tắc (Q&A):
        \nQ: Liên hệ phục nội dung trò chơi cùng không phải liên hệ phục có cái gì khác nhau?
        \nA: Trò chơi cách chơi hoàn toàn nhất trí.
        \n\nQ: Liên hệ phục trữ giá trị đường ống sẽ thay đổi sao?
        \nA: Tư liệu liên hệ sau, trữ giá trị phương thức đem dựa theo nguyên lai phương thức, tự hành lựa chọn cần trữ giá trị khu phục tiến hành trữ giá trị.
        \n\nQ: Liên hệ phục bên trong iOS Trữ giá trị cùng Android trữ giá trị chiết khấu nhất trí sao?
        \nA: Vì cam đoan trò chơi tính công bình, bảo đảm liên hệ phục bên trong iOS Bình đài trữ giá trị cùng Android bình đài trữ giá trị chiết khấu nhất trí, đương iOS Người sử dụng tiến hành trữ giá trị tiêu phí sau, chúng ta sẽ dẹp an trác chiết khấu tiêu chuẩn đối nên bút trữ giá trị chênh lệch giá trị tiến hành ngoài định mức Nguyên bảo đưa tặng, mời người chơi thông qua trong trò chơi thư tín phụ kiện kiểm tra và nhận.
        \n\nQ: Liên hệ phục tư liệu liên hệ công năng thực hiện sau, trước mắt đã khai phục server cũng sẽ sử dụng tư liệu liên hệ công năng tiến hành sát nhập sao?
        \nA: Sẽ không.
        \n\nQ: Ta sử dụng cùng một cái số tài khoản có thể đồng thời sử dụng iOS Cùng Android điện thoại đăng nhập cùng một tổ liên hệ phục sao?
        \nA: Không thể.
        \n\nQ: Ta sử dụng hệ thống là iOS, tái sử dụng Android điện thoại đăng nhập tại sao không có nhân vật?
        \nA: Đăng nhập số tài khoản tại iOS Cùng Android thiết bị ở giữa tương hỗ độc lập, số tài khoản bên trong nhân vật không cách nào tại các bình đài tự do hoán đổi, sử dụng hệ thống khác biệt thiết bị đăng nhập trò chơi lúc, cho dù là cùng một cái số tài khoản, cũng là khác biệt nhân vật, tức iOS Cùng Android tư liệu liên hệ sau, nếu như liên hệ phục đều có nhân vật, là không ảnh hưởng riêng phần mình nhân vật tư liệu.
        \n\nQ: Ta trước đó một mực sử dụng Android điện thoại tại liên hệ phục thể nghiệm trò chơi, sau đó thay đổi quả táo điện thoại thể nghiệm, đăng nhập sau còn có thể tiếp tục chơi trước kia nhân vật sao?
        \nA: Không thể. Liên hệ phục bên trong, đồng dạng đăng nhập số tài khoản, iOS Cùng Android dưới bình đài số tài khoản thông tin là hoàn toàn độc lập. Tức: Thay đổi thành iOS Thiết bị đăng nhập sau, cho dù là giống nhau server giống nhau số tài khoản, cũng không nhìn thấy nên số tài khoản tại Android bên trên sáng tạo nhân vật, trái lại cũng thế.
        \n\nQ: Liên hệ phục bên trong, có thể hay không tồn tại cùng ta giống nhau như đúc nhân vật tên tồn tại?
        \nA: Nhân vật tên đều là toàn bộ server duy nhất.
        \n\nQ: Xin hỏi liên hệ phục bên trong ta có thể nhận lấy đến đối ứng bình đài gói quà sao?
        \nA: Có thể.
        \n\nQ: Xin hỏi liên hệ phục bên trong các loại bảng xếp hạng là phân biệt phân chia khác biệt bình đài sao?
        \nA: Liên hệ phục bên trong, bảng xếp hạng tư liệu chính là nên phục toàn thể người chơi tư liệu căn cứ các loại bảng xếp hạng quy tắc tiến hành sắp xếp.
        \n\nQ: Thế nào phân chia ta tiến vào server phải chăng liên hệ server?
        \nA: Liên hệ server danh tự lấy liên hệ phục mệnh danh.
		]]
		local tbActData = {string.format(szContent)}
		local bRet = NewInformation:AddInfomation("CrossEachServerAct", GetTime() + self.nNewInfomationValidTime, tbActData, {szTitle = "Liên hệ phục kỹ càng quy tắc"});
		if not bRet then
			Log("[CrossEachServerAct] send new msg fail")
		end
	end
end