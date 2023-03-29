
local hpdf = require "hpdf"
require "common"


local SAMP_TXT = "The quick brown fox jumps over the lazy dog. ";
local fname = "text_demo2.pdf";

local pdf = hpdf.New()
if pdf then
    local page = hpdf.AddPage(pdf)
    hpdf.Page_SetSize(page, "HPDF_PAGE_SIZE_A5", "HPDF_PAGE_PORTRAIT");
    --hpdf.print_grid(pdf, page);
    local page_height = hpdf.Page_GetHeight (page);

    local font = hpdf.GetFont(pdf, "Helvetica");
    hpdf.Page_SetTextLeading(page, 20);

    --/* HPDF_TALIGN_LEFT */
    local rect = {};
    rect.left = 25;
    rect.top = 545;
    rect.right = 200;
    rect.bottom = rect.top - 40;

    hpdf.Page_Rectangle(page, rect.left, rect.bottom, rect.right - rect.left, rect.top - rect.bottom);

    hpdf.Page_Stroke(page);
    hpdf.Page_BeginText(page);

    hpdf.Page_SetFontAndSize (page, font, 10);
    hpdf.Page_TextOut (page, rect.left, rect.top + 3, "HPDF_TALIGN_LEFT");

    hpdf.Page_SetFontAndSize (page, font, 13);
    hpdf.Page_TextRect (page, rect.left, rect.top, rect.right, rect.bottom,
            SAMP_TXT, "HPDF_TALIGN_LEFT");

    hpdf.Page_EndText(page);

    --/* HPDF_TALIGN_RIGTH */
    rect.left = 220;
    rect.right = 395;

    hpdf.Page_Rectangle (page, rect.left, rect.bottom, rect.right - rect.left,
                rect.top - rect.bottom);
    hpdf.Page_Stroke (page);

    hpdf.Page_BeginText (page);

    hpdf.Page_SetFontAndSize (page, font, 10);
    hpdf.Page_TextOut (page, rect.left, rect.top + 3, "HPDF_TALIGN_RIGTH");

    hpdf.Page_SetFontAndSize (page, font, 13);
    hpdf.Page_TextRect (page, rect.left, rect.top, rect.right, rect.bottom,
                SAMP_TXT, "HPDF_TALIGN_RIGHT");

    hpdf.Page_EndText (page);

    --/* HPDF_TALIGN_CENTER */
    rect.left = 25;
    rect.top = 475;
    rect.right = 200;
    rect.bottom = rect.top - 40;

    hpdf.Page_Rectangle (page, rect.left, rect.bottom, rect.right - rect.left,
                rect.top - rect.bottom);
    hpdf.Page_Stroke (page);

    hpdf.Page_BeginText (page);

    hpdf.Page_SetFontAndSize (page, font, 10);
    hpdf.Page_TextOut (page, rect.left, rect.top + 3, "HPDF_TALIGN_CENTER");

    hpdf.Page_SetFontAndSize (page, font, 13);
    hpdf.Page_TextRect (page, rect.left, rect.top, rect.right, rect.bottom,
                SAMP_TXT, "HPDF_TALIGN_CENTER");

    hpdf.Page_EndText (page);

    --/* HPDF_TALIGN_JUSTIFY */
    rect.left = 220;
    rect.right = 395;

    hpdf.Page_Rectangle (page, rect.left, rect.bottom, rect.right - rect.left,
                rect.top - rect.bottom);
    hpdf.Page_Stroke (page);

    hpdf.Page_BeginText (page);

    hpdf.Page_SetFontAndSize (page, font, 10);
    hpdf.Page_TextOut (page, rect.left, rect.top + 3, "HPDF_TALIGN_JUSTIFY");

    hpdf.Page_SetFontAndSize (page, font, 13);
    hpdf.Page_TextRect (page, rect.left, rect.top, rect.right, rect.bottom,
                SAMP_TXT, "HPDF_TALIGN_JUSTIFY");

    hpdf.Page_EndText (page);


    --/* Skewed coordinate system */
    hpdf.Page_GSave (page);

    local angle1 = 5;
    local angle2 = 10;
    local rad1 = angle1 / 180 * 3.141592;
    local rad2 = angle2 / 180 * 3.141592;

    hpdf.Page_Concat (page, 1, math.tan(rad1), math.tan(rad2), 1, 25, 350);
    rect.left = 0;
    rect.top = 40;
    rect.right = 175;
    rect.bottom = 0;

    hpdf.Page_Rectangle (page, rect.left, rect.bottom, rect.right - rect.left,
                rect.top - rect.bottom);
    hpdf.Page_Stroke (page);

    hpdf.Page_BeginText (page);

    hpdf.Page_SetFontAndSize (page, font, 10);
    hpdf.Page_TextOut (page, rect.left, rect.top + 3, "Skewed coordinate system");

    hpdf.Page_SetFontAndSize (page, font, 13);
    hpdf.Page_TextRect (page, rect.left, rect.top, rect.right, rect.bottom,
                SAMP_TXT, "HPDF_TALIGN_LEFT");

    hpdf.Page_EndText (page);

    hpdf.Page_GRestore (page);



    --/* Rotated coordinate system */
    hpdf.Page_GSave (page);

    angle1 = 5;
    rad1 = angle1 / 180 * 3.141592;

    hpdf.Page_Concat (page, math.cos(rad1), math.sin(rad1), -math.sin(rad1), math.cos(rad1), 220, 350);
    rect.left = 0;
    rect.top = 40;
    rect.right = 175;
    rect.bottom = 0;

    hpdf.Page_Rectangle (page, rect.left, rect.bottom, rect.right - rect.left,
                rect.top - rect.bottom);
    hpdf.Page_Stroke (page);

    hpdf.Page_BeginText (page);

    hpdf.Page_SetFontAndSize (page, font, 10);
    hpdf.Page_TextOut (page, rect.left, rect.top + 3, "Rotated coordinate system");

    hpdf.Page_SetFontAndSize (page, font, 13);
    hpdf.Page_TextRect (page, rect.left, rect.top, rect.right, rect.bottom,
                SAMP_TXT, "HPDF_TALIGN_LEFT");

    hpdf.Page_EndText (page);

    hpdf.Page_GRestore (page);


    --/* text along a circle */
    hpdf.Page_SetGrayStroke (page, 0);
    hpdf.Page_Circle (page, 210, 190, 145);
    hpdf.Page_Circle (page, 210, 190, 113);
    hpdf.Page_Stroke (page);

    angle1 = 360 / (# (SAMP_TXT));
    angle2 = 180;

    hpdf.Page_BeginText (page);
    font = hpdf.GetFont (pdf, "Courier-Bold", NULL);
    hpdf.Page_SetFontAndSize (page, font, 30);

    for i = 1, #SAMP_TXT, 1 do
        local buf;
        local x;
        local y;

        rad1 = (angle2 - 90) / 180 * 3.141592;
        rad2 = angle2 / 180 * 3.141592;

        x = 210 + math.cos(rad2) * 122;
        y = 190 + math.sin(rad2) * 122;

        hpdf.Page_SetTextMatrix(page, math.cos(rad1), math.sin(rad1), -math.sin(rad1), math.cos(rad1), x, y);

        buf = string.sub(SAMP_TXT, i, i);
        hpdf.Page_ShowText (page, buf);
        angle2 = angle2 - angle1;
    end

    hpdf.Page_EndText (page);

    -- save the document to a file
    save_to_file(pdf, arg[0])

    -- clean up
    hpdf.Free(pdf)

    return 0
else
    io.write("Error creating PDF object\n")
end -- if

