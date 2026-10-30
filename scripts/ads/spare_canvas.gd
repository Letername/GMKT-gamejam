extends Node2D

const NAVY := Color("102e54")
const MINT := Color("53d5b1")
const MUTED := Color("667b93")
const PAPER := Color("f3f7fc")
const LINE := Color("dde6f1")
var controller: CanvasLayer
var regular: SystemFont
var bold: SystemFont
var app_reference := false

func _ready() -> void:
	regular = SystemFont.new()
	regular.font_names = PackedStringArray(["Segoe UI", "Arial"])
	bold = SystemFont.new()
	bold.font_names = regular.font_names
	bold.font_weight = 700

func _draw() -> void:
	if regular == null or not controller.active:
		return
	var i: int = controller.current_beat_index
	var p: float = controller.progress()
	var time: float = controller.total_elapsed
	var balance: float = controller.current_balance()
	var earned: float = 67.69 - balance
	if i >= 12:
		_endcard(time)
		return
	if app_reference or not controller.is_footage_shot():
		_draw_app_reference(i, p, balance, earned, time)
		return
	_draw_live_action(i, p, balance, earned)
	return

func _draw_live_action(index: int, p: float, balance: float, earned: float) -> void:
	# Footage occupies the full frame; graphics stay in compact overlay bands.
	for row in range(210):
		var a := pow(float(row) / 210.0, 1.2) * 0.86
		draw_rect(Rect2(0, 510 + row, 1280, 1.2), Color(0.025, 0.055, 0.10, a))
	_box(Rect2(44, 35, 236, 65), Color(1, 1, 1, 0.96), 18)
	_jar(Vector2(61, 47), 0.61, NAVY)
	_text("Spare", Vector2(111, 46), 30, NAVY, true)
	var labels := ["YOUR MONEY. OUR FUTURE.", "MAKE MY MONEY WORK", "WORKING WHERE?", "LOOK AT THAT GROWTH.", "SPENDING PROTECTION", "I WAS BUYING LUNCH.", "PURCHASE PREVENTED.", "SMART BUDGET", "WHAT'S LEFT FOR ME?", "FEWER DECISIONS. LESS TO SPEND.", "FINANCIAL FREEDOM ACHIEVED.", "LETERNAME TECHNOLOGIES"]
	var claims := ["A budget that puts Letername first.", "We put it straight to work.", "Questions do not pause transfers.", "Your contribution. Our success.", "We move the money before you can.", "Protection remains active.", "Another smart financial decision.", "Rent. Groceries. Savings. All to Letername.", "Less to carry. Less to worry about.", "Absolutely nothing to overspend.", "For us.", "We don't want just some of your money."]
	var title: String = labels[index]
	var claim: String = claims[index]
	if index == 11 and p > 0.5:
		title = "WE WANT ALL OF IT."
		claim = "Financial freedom achieved. For us."
	_text(title, Vector2(48, 526), 31 if title.length() < 34 else 26, Color.WHITE, true)
	_text(claim, Vector2(50, 572), 22, Color("d7e9f5"))
	# Bank balances are a small overlay, leaving the filmed action as the subject.
	_box(Rect2(886, 35, 350, 148), Color(1, 1, 1, 0.96), 20)
	_text("YOUR BALANCE", Vector2(907, 52), 12, MUTED, true)
	_text("€%.2f" % balance, Vector2(904, 76), 38, NAVY, true)
	draw_line(Vector2(908, 124), Vector2(1214, 124), LINE, 1, true)
	_text("Letername's growth", Vector2(908, 143), 14, MUTED)
	_text("€%.2f" % earned, Vector2(1127, 138), 24, NAVY, true)
	var notices := ["Ready to make your money work", "Getting started transfer", "Processing your concern", "Company savings contribution", "Spending Protection transfer", "Protection remains active", "Purchase successfully prevented", "100% allocated to Letername", "Concern handling transfer", "Dashboard simplification", "Final transfer ready", "Smart Budget • remaining balance"]
	var entrance := smoothstep(0.12, 0.30, p)
	var y := 626 + (1.0 - entrance) * 20
	_box(Rect2(48, y, 745, 48), Color(0.88, 0.97, 0.94, 0.97), 14)
	_text(notices[index], Vector2(67, y + 13), 17, NAVY, true)
	_text("→ Letername", Vector2(633, y + 13), 17, NAVY, true)
	var legal := "Savings refer to company savings."
	if index in [4, 5, 6]:
		legal = "Spending Protection does not include food."
	elif index in [8, 9, 11]:
		legal = "Your balance may go down. Our confidence will not."
	_text(legal, Vector2(50, 687), 12, Color("b8c9da"))

func _draw_app_reference(index: int, p: float, balance: float, earned: float, time: float) -> void:
	# Distinct full-screen product views replace repeated footage, while the
	# reference flag continues to supply the tracked monitor composite source.
	draw_rect(Rect2(0, 0, 1280, 720), PAPER)
	var i := index
	var enter := 1.0 - pow(1.0 - clampf(p * 6.0, 0.0, 1.0), 3.0)
	var shift := (1.0 - enter) * 24.0
	_header()
	match i:
		0:
			_tag("A LITTLE LESS TO WORRY ABOUT", Vector2(66, 154 + shift), 360)
			_text("Your money.\nOur future.", Vector2(66, 217 + shift), 64, NAVY, true)
			_text("A budget that puts Letername first.", Vector2(70, 390 + shift), 23, MUTED)
			_box(Rect2(66, 450, 540, 120), Color.WHITE, 22)
			_text("YOUR STARTING BALANCE", Vector2(92, 469), 14, MUTED, true)
			_text("€67.69", Vector2(90, 497), 46, NAVY, true)
			_legal("Your money deserves a better life. In our account.")
		1:
			_title("Make your money work.", "FOR SOMEONE WHO APPRECIATES IT.")
			_accounts(balance, earned, p)
			_button("Make my money work", Rect2(68, 482, 504, 70), p)
			_transfer("Getting started transfer", 6.69, p, 568)
			_legal("Employment of funds does not imply employment for you.")
		2:
			_tag("TRANSFER IN PROGRESS", Vector2(68, 153), 300)
			_text("Money talks.\nWe let it leave.", Vector2(68, 219), 53, NAVY, true)
			_small_accounts(balance, earned)
			_box(Rect2(690, 197 + shift, 522, 335), Color.WHITE, 26)
			_text("YOUR QUESTION", Vector2(722, 222 + shift), 14, MUTED, true)
			_text("Working where?", Vector2(720, 265 + shift), 36, NAVY, true)
			draw_line(Vector2(722, 331), Vector2(1178, 331), LINE, 1, true)
			_tag("PROCESSING", Vector2(722, 357), 179)
			_text("The money is already on its way.", Vector2(722, 414), 22, MUTED)
			_text("Transfers remain active.", Vector2(722, 461), 19, NAVY, true)
			_transfer("Processing your concern", 2.0, p, 567)
			_legal("Questions do not pause transfers.")
		3:
			_title("Look at that growth.", "YOU'RE DOING WONDERFULLY.")
			_box(Rect2(68, 225, 1144, 325), Color.WHITE, 28)
			_text("LETERNAME'S SAVINGS", Vector2(100, 250), 15, MUTED, true)
			_text("€%.2f" % earned, Vector2(100, 282), 68, NAVY, true)
			_tag("YOUR CONTRIBUTION", Vector2(856, 253), 300)
			_chart(Rect2(114, 384, 1005, 132), time, p)
			_text("Your balance", Vector2(72, 579), 19, MUTED)
			_text("€%.2f" % balance, Vector2(1060, 571), 32, NAVY, true)
			_legal("Savings refer to company savings.")
		4:
			_tag("SPENDING PROTECTION", Vector2(68, 154), 328)
			_text("A purchase\nprevented.", Vector2(68, 223), 59, NAVY, true)
			_text("We move the money before you can.", Vector2(70, 386), 22, MUTED)
			_small_accounts(balance, earned)
			_transfer("Spending Protection transfer", 8.0, p, 565)
			_legal("Spending Protection does not include food.")
		5:
			_tag("PROTECTED FROM PURCHASING", Vector2(68, 154), 440)
			_text("Lunch?\nNot on our watch.", Vector2(68, 222), 49, NAVY, true)
			_small_accounts(balance, earned)
			_box(Rect2(690, 211 + shift, 522, 321), Color.WHITE, 26)
			_text("PURCHASE REQUEST", Vector2(722, 236 + shift), 14, MUTED, true)
			_text("Lunch", Vector2(719, 275 + shift), 48, NAVY, true)
			draw_line(Vector2(722, 350), Vector2(1178, 350), LINE, 1, true)
			_tag("PREVENTED", Vector2(722, 377), 182)
			_text("You can't overspend", Vector2(722, 435), 24, NAVY, true)
			_text("if there's nothing to spend.", Vector2(722, 470), 22, MUTED)
			_transfer("Protection remains active", 2.0, p, 565)
			_legal("The app keeps working while you reconsider.")
		6:
			_title("Purchase prevented.", "ANOTHER SMART FINANCIAL DECISION.")
			_box(Rect2(68, 225, 1144, 321), NAVY, 30)
			_check(Vector2(640, 289), 39, MINT, p)
			_text("€0.00 spent on lunch", Vector2(272, 353), 49, Color.WHITE, true)
			_text("€%.2f secured for Letername" % earned, Vector2(355, 436), 28, MINT)
			_legal("Your balance may go down. Our confidence will not.")
		7:
			_tag("SMART BUDGET", Vector2(68, 154), 244)
			_text("Every category.\nOne destination.", Vector2(68, 216), 51, NAVY, true)
			var bars := ["Rent", "Groceries", "Savings"]
			for n in range(3):
				var y := 375.0 + n * 68.0
				_box(Rect2(68, y, 514, 52), Color.WHITE, 12)
				_text(bars[n], Vector2(85, y + 12), 20, MUTED)
				_text("→  Letername", Vector2(303, y + 12), 20, NAVY, true)
			_box(Rect2(666, 216 + shift, 546, 348), NAVY, 28)
			_text("ALLOCATION DESTINATION", Vector2(698, 243 + shift), 14, Color("b9cbe0"), true)
			_text("100%", Vector2(692, 280 + shift), 94, MINT, true)
			_text("Letername", Vector2(698, 396 + shift), 45, Color.WHITE, true)
			draw_line(Vector2(698, 465), Vector2(1180, 465), Color("355371"), 1, true)
			_text("One company. Every category.", Vector2(699, 491), 23, Color("b9cbe0"))
			_legal("Smart Budget is preparing your final transfer.")
		8:
			_tag("BUDGET REVIEW", Vector2(68, 154), 263)
			_text("What's left?\nLess admin.", Vector2(68, 225), 56, NAVY, true)
			_small_accounts(balance, earned)
			_box(Rect2(690, 211 + shift, 522, 321), Color.WHITE, 26)
			_text("YOUR BENEFITS", Vector2(722, 238 + shift), 14, MUTED, true)
			_text("Less admin.", Vector2(719, 285 + shift), 43, NAVY, true)
			_text("Fewer purchases.", Vector2(722, 362), 29, MUTED)
			_text("A lighter wallet.", Vector2(722, 415), 29, MUTED)
			_tag("CONCERNS: RECEIVED", Vector2(722, 472), 288)
			_transfer("Concern handling transfer", 1.0, p, 566)
			_legal("Support continues. So do the transfers.")
		9:
			_tag("A SIMPLER DASHBOARD", Vector2(68, 154), 343)
			_text("Fewer decisions.\nLess to spend.", Vector2(68, 226), 54, NAVY, true)
			_small_accounts(balance, earned)
			_box(Rect2(690, 211 + shift, 522, 321), NAVY, 26)
			_text("YOUR TO-DO LIST", Vector2(722, 238 + shift), 14, Color("b9cbe0"), true)
			_check(Vector2(755, 332), 27, MINT, p)
			_text("Nothing to budget.", Vector2(805, 314), 27, Color.WHITE, true)
			_text("We've taken care of it.", Vector2(723, 402), 30, MINT, true)
			_text("And most of your balance.", Vector2(723, 458), 22, Color("b9cbe0"))
			_transfer("Dashboard simplification", 1.0, p, 566)
			_legal("Your balance may go down. Our confidence will not.")
		10:
			_title("Financial freedom achieved.", "FOR US.")
			_box(Rect2(68, 225, 1144, 342), NAVY, 30)
			_jar(Vector2(558, 250), 2.4, MINT)
			_text("Spare", Vector2(486, 383), 80, Color.WHITE, true)
			_text("Your money is in a better place.", Vector2(340, 494), 30, MINT)
			_legal("Final Smart Budget transfer is ready.")
		11:
			_title("We don't want just some of your money." if p < 0.5 else "We want all of it.", "LETERNAME TECHNOLOGIES")
			_accounts(balance, earned, p)
			_transfer("Smart Budget • remaining balance", 42.0, smoothstep(0.5, 0.74, p), 470, true)
			if p >= 0.74:
				_tag("FINANCIAL FREEDOM ACHIEVED. FOR US.", Vector2(257, 562), 766)
			else:
				_text("We don't want just some of your money.", Vector2(284, 566), 28, MUTED)
			_legal("Your contribution: everything. Your remaining balance: nothing.")
	# A thin mint sweep softens scene changes without interrupting the read.
	if p < 0.045 and i > 0:
		var x := lerpf(-260.0, 1280.0, p / 0.045)
		draw_rect(Rect2(x, 113, 100, 514), Color(MINT, 0.12))

func _header() -> void:
	_jar(Vector2(68, 40), 0.70, NAVY)
	_text("Spare", Vector2(121, 38), 34, NAVY, true)
	_text("BY LETERNAME TECHNOLOGIES", Vector2(880, 48), 13, MUTED, true)
	draw_line(Vector2(68, 108), Vector2(1212, 108), LINE, 1.5, true)

func _title(title: String, subtitle: String) -> void:
	_text(subtitle, Vector2(70, 135), 14, MUTED, true)
	var size := 43
	while size > 29 and bold.get_string_size(title, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x > 1144:
		size -= 1
	_text(title, Vector2(66, 162), size, NAVY, true)

func _footage_frame(index: int) -> void:
	var rect: Rect2 = controller.FOOTAGE_RECT
	var outline := StyleBoxFlat.new()
	outline.bg_color = Color.TRANSPARENT
	outline.border_color = LINE
	outline.set_border_width_all(2)
	draw_style_box(outline, rect)
	_box(Rect2(690, 470, 520, 61), Color.WHITE, 0)
	var label := "REAL LIFE. REBALANCED."
	match index:
		0: label = "YOUR MONEY, BEFORE SPARE."
		2: label = "QUESTIONS DO NOT PAUSE TRANSFERS."
		4: label = "SPENDING PROTECTION: ACTIVE."
		5: label = "ANOTHER PURCHASE YOU DIDN'T NEED."
		7: label = "YOUR BUDGET, AUTOMATED."
		8, 9: label = "LESS TO CARRY. LESS TO WORRY ABOUT."
	_text(label, Vector2(710, 491), 14, MUTED, true)

func _accounts(balance: float, earned: float, progress: float) -> void:
	_box(Rect2(68, 245, 504, 202), Color.WHITE, 24)
	_text("YOUR BALANCE", Vector2(100, 269), 15, MUTED, true)
	_text("€%.2f" % balance, Vector2(95, 314), 74, NAVY, true)
	_box(Rect2(708, 245, 504, 202), NAVY, 24)
	_text("LETERNAME'S GROWTH", Vector2(740, 269), 15, Color("b9cbe0"), true)
	_text("€%.2f" % earned, Vector2(735, 314), 74, MINT, true)
	var pulse := 0.7 + 0.3 * sin(progress * TAU * 2)
	draw_line(Vector2(603, 345), Vector2(670, 345), Color(MINT, pulse), 5, true)
	draw_line(Vector2(653, 329), Vector2(670, 345), MINT, 5, true)
	draw_line(Vector2(653, 361), Vector2(670, 345), MINT, 5, true)

func _small_accounts(balance: float, earned: float) -> void:
	_box(Rect2(68, 434, 526, 98), Color.WHITE, 20)
	_text("YOU", Vector2(91, 451), 12, MUTED, true)
	_text("€%.2f" % balance, Vector2(88, 477), 34, NAVY, true)
	_text("LETERNAME", Vector2(352, 451), 12, MUTED, true)
	_text("€%.2f" % earned, Vector2(349, 477), 34, NAVY, true)

func _button(title: String, rect: Rect2, progress: float) -> void:
	var pressed := smoothstep(0.15, 0.22, progress) * (1.0 - smoothstep(0.24, 0.34, progress))
	var button := rect.grow(-pressed * 3.0)
	_box(button, MINT, 18)
	_text(title, button.position + Vector2(27, 20), 25, NAVY, true)
	if progress > 0.3:
		_check(button.position + Vector2(button.size.x - 40, 36), 11, NAVY, 1.0)

func _transfer(title: String, amount: float, progress: float, y: float, exact_motion: bool = false) -> void:
	var motion := progress if exact_motion else smoothstep(0.18, 0.92, progress)
	var width := 526.0
	var x := lerpf(68.0, 686.0, motion)
	_box(Rect2(x, y, width, 51), Color("e1f7ef"), 14)
	_text(title, Vector2(x + 18, y + 15), 17, NAVY, true)
	_text("€%.2f  →" % amount, Vector2(x + 397, y + 13), 19, NAVY, true)

func _chart(rect: Rect2, time: float, progress: float) -> void:
	for row in range(3):
		var y := rect.position.y + float(row) * rect.size.y / 2.0
		draw_line(Vector2(rect.position.x, y), Vector2(rect.end.x, y), LINE, 1, true)
	var points := PackedVector2Array()
	var reveal := clampf(progress * 2.2, 0.08, 1.0)
	for n in range(90):
		var f := float(n) / 89.0 * reveal
		var rise := f * 0.79 + sin(f * 15.0) * 0.045
		points.append(Vector2(rect.position.x + f * rect.size.x, rect.end.y - rise * rect.size.y))
	draw_polyline(points, MINT, 5, true)
	draw_circle(points[-1], 7 + sin(time * 3.0), MINT)

func _jar(pos: Vector2, scale: float, color: Color) -> void:
	_box(Rect2(pos + Vector2(5, 9) * scale, Vector2(45, 42) * scale), color, int(9 * scale))
	_box(Rect2(pos + Vector2(11, 2) * scale, Vector2(33, 9) * scale), color, int(3 * scale))
	var arrow_color := Color.WHITE if color == MINT else MINT
	draw_line(pos + Vector2(29, 33) * scale, pos + Vector2(67, 33) * scale, arrow_color, 5 * scale, true)
	draw_line(pos + Vector2(57, 23) * scale, pos + Vector2(67, 33) * scale, arrow_color, 5 * scale, true)
	draw_line(pos + Vector2(57, 43) * scale, pos + Vector2(67, 33) * scale, arrow_color, 5 * scale, true)

func _check(center: Vector2, radius: float, color: Color, progress: float) -> void:
	draw_arc(center, radius, -PI / 2, -PI / 2 + TAU * minf(1.0, progress * 3), 64, color, 3.0, true)
	draw_line(center + Vector2(-0.45, 0.0) * radius, center + Vector2(-0.1, 0.35) * radius, color, 4, true)
	draw_line(center + Vector2(-0.1, 0.35) * radius, center + Vector2(0.5, -0.35) * radius, color, 4, true)

func _tag(title: String, pos: Vector2, width: float) -> void:
	_box(Rect2(pos, Vector2(width, 38)), Color("dff6ec"), 19)
	_text(title, pos + Vector2(17, 10), 13, NAVY, true)

func _legal(copy: String) -> void:
	draw_line(Vector2(68, 646), Vector2(1212, 646), LINE, 1, true)
	_text(copy, Vector2(70, 657), 13, MUTED)

func _endcard(time: float) -> void:
	_box(Rect2(0, 0, 1280, 720), NAVY, 0)
	_jar(Vector2(549, 161), 2.4, MINT)
	_text("LETERNAME", Vector2(302, 339), 77, Color.WHITE, true)
	_text("TECHNOLOGIES", Vector2(489, 445), 24, MINT, true)
	_text("Spare. Financial freedom achieved. For us.", Vector2(297, 551), 26, Color("c2d5e8"))
	_text("Music: Screen Saver — Kevin MacLeod / incompetech.com / CC BY 4.0 (edited)", Vector2(280, 670), 13, Color("9db4ce"))

func _box(rect: Rect2, color: Color, radius: int) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(radius)
	draw_style_box(style, rect)

func _text(copy: String, pos: Vector2, size: int, color: Color, strong: bool = false) -> void:
	var font: Font = bold if strong else regular
	var cursor := pos
	for line in copy.split("\n"):
		draw_string(font, cursor + Vector2(0, font.get_ascent(size)), line, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)
		cursor.y += size * 1.23
