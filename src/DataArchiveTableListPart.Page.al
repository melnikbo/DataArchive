// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved. 
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Shows the tables belonging to an archive
/// </summary>

namespace System.DataAdministration;

page 632 "Data Archive Table ListPart"
{
    ApplicationArea = All;
    Caption = 'Archived Tables';
    PageType = ListPart;
    Editable = false;
    SourceTable = "Data Archive Table";
    SourceTableView = sorting("Table No.", "Created On");
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the archived table.';
                }
                field("No. of Records"; Rec."No. of Records")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of records stored in this record.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SaveAsExcel)
            {
                ApplicationArea = All;
                Caption = 'Save as Excel';
                ToolTip = 'Saves the contents of this data archive record as Excel.';
                Image = ExportToExcel;

                trigger OnAction()
                var
                    DataArchiveTable: Record "Data Archive Table";
                begin
                    DataArchiveTable.SetRange("Data Archive Entry No.", Rec."Data Archive Entry No.");
                    DataArchiveTable.SetRange("Table No.", Rec."Table No.");
                    DataArchiveTable.SetRange("Entry No.", Rec."Entry No.");
                    Codeunit.Run(Codeunit::"Data Archive Export To Excel", DataArchiveTable);
                end;
            }
            action(SaveToCSV)
            {
                ApplicationArea = All;
                Caption = 'Save as CSV';
                ToolTip = 'Saves the contents of this data archive record in a CSV format.';
                image = ExportFile;

                trigger OnAction()
                var
                    DataArchiveTable: Record "Data Archive Table";
                begin
                    DataArchiveTable.SetRange("Data Archive Entry No.", Rec."Data Archive Entry No.");
                    DataArchiveTable.SetRange("Table No.", Rec."Table No.");
                    DataArchiveTable.SetRange("Entry No.", Rec."Entry No.");
                    Codeunit.Run(Codeunit::"Data Archive Export To CSV", DataArchiveTable);
                end;
            }
            action(ShowTableInfo)
            {
                ApplicationArea = All;
                Caption = 'Table Info';
                ToolTip = 'Shows information about the selected archived table.';
                Image = Info;

                trigger OnAction()
                begin
                    Message(TableInfoLbl, Rec."Table Name", Rec."No. of Records");
                end;
            }
        }
    }

    var
        TableInfoLbl: Label 'Table: %1 | Records: %2', Locked = true;
}
