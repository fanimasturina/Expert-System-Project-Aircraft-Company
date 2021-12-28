import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Vector;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

import jess.JessException;
import jess.QueryResult;
import jess.Rete;
import jess.ValueVector;

public class Template extends JFrame
{	
	private static final long serialVersionUID = 1L;
	JPanel content_panel = new JPanel(new FlowLayout(FlowLayout.CENTER, 30, 30));
	static Rete rete = new Rete();
	
	JButton btnClose = new JButton("Close");
	
	Vector<String> header = new Vector<String>();
	Vector<Vector<String>> data = new Vector<Vector<String>>();
	Vector<String> row;
	
	DefaultTableModel defaultTableModel;
	JTable table;
	JScrollPane scrollPane;
	
	final Template frame = this;
	
	public void initComponents()
	{
		getContentPane().setLayout(new BorderLayout());
		
		JLabel lblTitle = new JLabel("No Match Found!", JLabel.CENTER);
		lblTitle.setFont(new Font(Font.MONOSPACED, Font.BOLD, 21));
		getContentPane().add(lblTitle, BorderLayout.NORTH);
		
		JPanel left_panel = new JPanel(new BorderLayout());
		JLabel lblHeader = new JLabel("Your Profile");
		lblHeader.setFont(new Font(Font.MONOSPACED, Font.BOLD, 15));
		left_panel.add(lblHeader, BorderLayout.NORTH);
		
		//Panel that contain all aircraft's info
		JPanel grid_panel = null;
		
		//Labels that contain aircraft's info
		JLabel lblYourName = new JLabel("Your Name: ");
		JLabel lblDemandedAircraft = new JLabel("Demanded Aircraft: ");
		JLabel lblMaterial = new JLabel("Demanded Material: ");
		JLabel lblEngineType = new JLabel("Demanded Engine Type: ");
		JLabel lblBudget = new JLabel("Your Budget: ");
		JLabel lblYourNameInfo = new JLabel();
		JLabel lblDemandedAircraftInfo = new JLabel();
		JLabel lblMaterialInfo = new JLabel();
		JLabel lblEngineTypeInfo = new JLabel();
		JLabel lblBudgetInfo = new JLabel();
		
		try {
			/*Modify Query Result Code Here*/
			QueryResult resultProfile = rete.runQueryStar("", new ValueVector());
			if(resultProfile.next()) {	
				lblYourNameInfo.setText(resultProfile.getString(""));
				lblDemandedAircraftInfo.setText(resultProfile.getString(""));
				lblMaterialInfo.setText(resultProfile.getString(""));
				lblBudgetInfo.setText(resultProfile.getString(""));
				if(lblDemandedAircraftInfo.getText().equals("")) {
					grid_panel = new JPanel(new GridLayout(5, 2));
					lblEngineTypeInfo.setText(resultProfile.getString(""));
				} else {
					grid_panel = new JPanel(new GridLayout(4, 2));
				}
			}
			resultProfile.close();
		}
		catch (JessException e) { 
			e.printStackTrace();
		}
		
		Object panel_add = null;
		panel_add = imageNotAvailable();
		
		/*Fill the code here to fetch all suitable match for user*/
		header.add("No.");
		header.add("Aircraft Name");
		header.add("Aircraft Material");
		if(lblDemandedAircraftInfo.getText().equals("Airplane"))header.add("Engine Type");
		header.add("Color");
		header.add("Fuel");
		header.add("Price");
		
		defaultTableModel = new DefaultTableModel(data, header);
		table = new JTable(defaultTableModel);
		scrollPane = new JScrollPane(table);
		
		int index = 0;
		if(lblDemandedAircraftInfo.getText().equals("Airplane")) {
			try {
				/*Modify Query Result Code Here*/
				QueryResult resultMatchWithAirplane = rete.runQueryStar("", new ValueVector());
				while(resultMatchWithAirplane.next()) {
					String name = resultMatchWithAirplane.getString("");
					String material = resultMatchWithAirplane.getString("");
					String engineType = resultMatchWithAirplane.getString("");
					String color = resultMatchWithAirplane.getString("");
					String fuel = resultMatchWithAirplane.getString("");
					String price = resultMatchWithAirplane.getString("");
					  
					row = new Vector<String>();
					row.add(Integer.toString(++index));
					row.add(name);
					row.add(material);
					row.add(engineType);
					row.add(color);
					row.add(fuel);
					row.add("$" + price+" USD");
					data.add(row);
				}
				resultMatchWithAirplane.close();
			}
			catch (JessException e1) {
				e1.printStackTrace();
			}
		} else if(lblDemandedAircraftInfo.getText().equals("Helicopter")){
			try {
				/*Modify Query Result Code Here*/
				QueryResult resultMatchWithHelicopter = rete.runQueryStar("", new ValueVector());
				while(resultMatchWithHelicopter.next()) {
					String name = resultMatchWithHelicopter.getString("");
					String material = resultMatchWithHelicopter.getString("");
					String color = resultMatchWithHelicopter.getString("");
					String fuel = resultMatchWithHelicopter.getString("");
					String price = resultMatchWithHelicopter.getString("");
					  
					row = new Vector<String>();
					row.add(Integer.toString(++index));
					row.add(name);
					row.add(material);
					row.add(color);
					row.add(fuel);
					row.add("$" + price+" USD");
					data.add(row);
				}
				resultMatchWithHelicopter.close();
			} catch (JessException e2) {
				e2.printStackTrace();
			}
		}
		
		if(data.size() != 0 ) {
			panel_add = scrollPane;
			lblTitle.setText("Matches Found!");
		}
		
		grid_panel.add(lblYourName);
		grid_panel.add(lblYourNameInfo);
		grid_panel.add(lblDemandedAircraft);
		grid_panel.add(lblDemandedAircraftInfo);
		grid_panel.add(lblMaterial);
		grid_panel.add(lblMaterialInfo);
		if(lblDemandedAircraftInfo.getText().equals("Airplane")){
			grid_panel.add(lblEngineType);
			grid_panel.add(lblEngineTypeInfo);
		}
		grid_panel.add(lblBudget);
		grid_panel.add(lblBudgetInfo);
		
		left_panel.add(grid_panel, BorderLayout.CENTER);
		
		content_panel.add(left_panel);
		content_panel.add((Component) panel_add);
		content_panel.setPreferredSize(new Dimension (900, 450));
		
		getContentPane().add(content_panel, BorderLayout.CENTER);
		getContentPane().add(btnClose, BorderLayout.PAGE_END);
		
		btnClose.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e){
				frame.dispose();
			}
		});
	}
	
	private Image getScaledImage(Image srcImage, int width, int height)
	{
		BufferedImage resizedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
		Graphics2D g2d = resizedImage.createGraphics();
		
		g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
		g2d.drawImage(srcImage, 0, 0, width, height, null);
		g2d.dispose();
		
		return resizedImage;
	}
	
	public JLabel imageNotAvailable()
	{
		JLabel lbl_img = new JLabel();
		lbl_img.setPreferredSize(new Dimension(320,180));
		Image bufferedImage;
		try
		{
			bufferedImage = ImageIO.read(getClass().getResource("not_available.jpg"));
			ImageIcon icon = new ImageIcon(getScaledImage(bufferedImage, 320, 180));
			lbl_img.setIcon(icon);
		}
		catch (IOException e)
		{
			return null;
		}
		return lbl_img;
	}
	
	public Template()
	{
		setTitle("The Result of Consultation");
		setSize(850, 450);
		setLocationRelativeTo(null);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		initComponents();
		setResizable(false);
		setVisible(true);
	}
	
	public static void main(String[] args) 
	{
		/*Modify Code Here*/
		try {
			rete.batch("");
		} catch (JessException e) {
			e.printStackTrace();
		}
	}
}
